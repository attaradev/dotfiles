#!/usr/bin/env python3
"""Generate Claude and Codex skill catalogs from canonical sources."""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
import tempfile
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Any

try:
    import tomllib
except ModuleNotFoundError:  # macOS system Python can be older than 3.11.
    tomllib = None


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = ROOT / "agent-skills"
DEFAULT_CLAUDE_OUT = ROOT / "claude" / ".claude" / "skills"
DEFAULT_CODEX_OUT = ROOT / "codex" / ".codex" / "skills"
RESOURCE_DIRS = {"references", "scripts", "assets"}
SKILL_NAME_RE = re.compile(r"^[a-z0-9][a-z0-9-]{0,62}$")
CLAUDE_ONLY_PATTERNS = (
    "$ARGUMENTS",
    "$HOME/.claude",
    "~/.claude",
)
CLAUDE_SHELL_INTERPOLATION_RE = re.compile(r"(^|[\s(:])!`")


@dataclass(frozen=True)
class Skill:
    name: str
    title: str
    body: str
    source_dir: Path
    claude_description: str
    claude_argument_hint: str
    claude_argument_label: str
    claude_live: str
    codex_description: str
    openai_display_name: str
    openai_short_description: str
    openai_default_prompt: str


def yaml_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def fail(message: str) -> None:
    raise ValueError(message)


def require_string(data: dict[str, Any], key: str, context: str) -> str:
    value = data.get(key)
    if not isinstance(value, str) or not value.strip():
        fail(f"{context}: missing required string `{key}`")
    return value.strip()


def _resolve_toml_table(data: dict[str, Any], header: str) -> dict[str, Any]:
    current: dict[str, Any] = data
    for part in header.split("."):
        current = current.setdefault(part, {})
    return current


def _parse_toml_assignment(raw_line: str, current: dict[str, Any]) -> None:
    if "=" not in raw_line:
        fail(f"invalid TOML line: {raw_line}")
    key, _, value = raw_line.partition("=")
    key = key.strip()
    try:
        current[key] = json.loads(value.strip())
    except json.JSONDecodeError as exc:
        fail(f"invalid TOML string for `{key}`: {exc}")


def loads_toml(text: str) -> dict[str, Any]:
    if tomllib is not None:
        return tomllib.loads(text)

    data: dict[str, Any] = {}
    current: dict[str, Any] = data
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("[") and line.endswith("]"):
            current = _resolve_toml_table(data, line[1:-1])
            continue
        _parse_toml_assignment(raw_line, current)
    return data


def _parse_metadata(
    metadata_path: Path, skill_dir: Path
) -> tuple[str, str, dict[str, Any], dict[str, Any], dict[str, Any]]:
    try:
        metadata = loads_toml(metadata_path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        raise ValueError(f"{skill_dir}: missing skill.toml")
    name = require_string(metadata, "name", str(metadata_path))
    title = require_string(metadata, "title", str(metadata_path))
    if not SKILL_NAME_RE.fullmatch(name):
        fail(f"{metadata_path}: invalid skill name `{name}`")
    if skill_dir.name != name:
        fail(f"{metadata_path}: directory name `{skill_dir.name}` must match skill name `{name}`")
    claude = metadata.get("claude")
    codex = metadata.get("codex")
    if not isinstance(claude, dict):
        fail(f"{metadata_path}: missing [claude] table")
    if not isinstance(codex, dict):
        fail(f"{metadata_path}: missing [codex] table")
    interface = codex.get("interface")
    if not isinstance(interface, dict):
        fail(f"{metadata_path}: missing [codex.interface] table")
    return name, title, claude, codex, interface


def _read_body(body_path: Path) -> str:
    try:
        body = body_path.read_text(encoding="utf-8").strip()
    except FileNotFoundError:
        raise ValueError(f"{body_path.parent}: missing body.md")
    if not body:
        fail(f"{body_path}: body must not be empty")
    for pattern in CLAUDE_ONLY_PATTERNS:
        if pattern in body:
            fail(f"{body_path}: shared body contains Claude-only pattern `{pattern}`")
    if CLAUDE_SHELL_INTERPOLATION_RE.search(body):
        fail(f"{body_path}: shared body contains Claude shell interpolation")
    return body


def load_skill(skill_dir: Path) -> Skill:
    metadata_path = skill_dir / "skill.toml"
    body_path = skill_dir / "body.md"
    name, title, claude, codex, interface = _parse_metadata(metadata_path, skill_dir)
    body = _read_body(body_path)

    live_path = skill_dir / "claude-live.md"
    claude_live = live_path.read_text(encoding="utf-8").strip() if live_path.exists() else ""

    return Skill(
        name=name,
        title=title,
        body=body,
        source_dir=skill_dir,
        claude_description=require_string(claude, "description", str(metadata_path)),
        claude_argument_hint=require_string(claude, "argument_hint", str(metadata_path)),
        claude_argument_label=(claude.get("argument_label") or "").strip(),
        claude_live=claude_live,
        codex_description=require_string(codex, "description", str(metadata_path)),
        openai_display_name=require_string(interface, "display_name", str(metadata_path)),
        openai_short_description=require_string(interface, "short_description", str(metadata_path)),
        openai_default_prompt=require_string(interface, "default_prompt", str(metadata_path)),
    )


def load_skills(source_dir: Path) -> list[Skill]:
    if not source_dir.exists():
        fail(f"Canonical skill source does not exist: {source_dir}")

    skills = [load_skill(path) for path in sorted(source_dir.iterdir()) if path.is_dir()]
    if not skills:
        fail(f"No canonical skills found in {source_dir}")

    counts = Counter(skill.name for skill in skills)
    duplicates = sorted(name for name, n in counts.items() if n > 1)
    if duplicates:
        fail(f"Duplicate skill names: {', '.join(duplicates)}")
    return skills


def reset_output_dir(output_dir: Path) -> None:
    shutil.rmtree(output_dir, ignore_errors=True)
    output_dir.mkdir(parents=True, exist_ok=True)


def copy_resources(skill: Skill, output_dir: Path) -> None:
    for resource_dir in RESOURCE_DIRS:
        source = skill.source_dir / resource_dir
        if source.exists():
            shutil.copytree(source, output_dir / resource_dir, copy_function=shutil.copy2)


def write_claude_skill(skill: Skill, output_root: Path) -> None:
    output_dir = output_root / skill.name
    output_dir.mkdir(parents=True, exist_ok=True)

    sections = [
        "---",
        f"name: {yaml_string(skill.name)}",
        f"description: {yaml_string(skill.claude_description)}",
        f"argument-hint: {yaml_string(skill.claude_argument_hint)}",
        "---",
        "",
        f"# {skill.title}",
        "",
    ]
    if skill.claude_argument_label:
        sections.extend([f"{skill.claude_argument_label}: $ARGUMENTS", ""])
    if skill.claude_live:
        sections.extend([skill.claude_live, ""])
    sections.append(skill.body)

    (output_dir / "SKILL.md").write_text("\n".join(sections).rstrip() + "\n", encoding="utf-8")
    copy_resources(skill, output_dir)


def write_codex_skill(skill: Skill, output_root: Path) -> None:
    output_dir = output_root / skill.name
    agents_dir = output_dir / "agents"
    output_dir.mkdir(parents=True, exist_ok=True)
    agents_dir.mkdir(parents=True, exist_ok=True)

    skill_md = "\n".join(
        [
            "---",
            f"name: {yaml_string(skill.name)}",
            f"description: {yaml_string(skill.codex_description)}",
            "---",
            "",
            f"# {skill.title}",
            "",
            skill.body,
        ]
    ).rstrip()
    (output_dir / "SKILL.md").write_text(skill_md + "\n", encoding="utf-8")

    openai_yaml = "\n".join(
        [
            "interface:",
            f"  display_name: {yaml_string(skill.openai_display_name)}",
            f"  short_description: {yaml_string(skill.openai_short_description)}",
            f"  default_prompt: {yaml_string(skill.openai_default_prompt)}",
        ]
    )
    (agents_dir / "openai.yaml").write_text(openai_yaml + "\n", encoding="utf-8")
    copy_resources(skill, output_dir)


def generate(skills: list[Skill], claude_out: Path, codex_out: Path) -> None:
    reset_output_dir(claude_out)
    reset_output_dir(codex_out)
    for skill in skills:
        write_claude_skill(skill, claude_out)
        write_codex_skill(skill, codex_out)


def validate_generated_catalog(output_root: Path, expected_names: set[str], label: str) -> None:
    actual_names = {path.name for path in output_root.iterdir() if path.is_dir()}
    if actual_names != expected_names:
        missing = sorted(expected_names - actual_names)
        extra = sorted(actual_names - expected_names)
        fail(f"{label}: generated skill set mismatch; missing={missing} extra={extra}")

    for name in expected_names:
        skill_md = output_root / name / "SKILL.md"
        if not skill_md.exists():
            fail(f"{label}: missing generated {skill_md}")
        if label == "codex" and not (output_root / name / "agents" / "openai.yaml").exists():
            fail(f"{label}: missing generated openai.yaml for {name}")


def check(source_dir: Path) -> None:
    skills = load_skills(source_dir)
    expected_names = {skill.name for skill in skills}
    with tempfile.TemporaryDirectory(prefix="agent-skills-check-") as tmp:
        tmp_root = Path(tmp)
        claude_out = tmp_root / "claude"
        codex_out = tmp_root / "codex"
        generate(skills, claude_out, codex_out)
        validate_generated_catalog(claude_out, expected_names, "claude")
        validate_generated_catalog(codex_out, expected_names, "codex")
    print(f"✓ Validated {len(skills)} canonical skill(s)")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--claude-out", type=Path, default=DEFAULT_CLAUDE_OUT)
    parser.add_argument("--codex-out", type=Path, default=DEFAULT_CODEX_OUT)
    parser.add_argument("--check", action="store_true", help="Validate by generating into a temporary directory")
    args = parser.parse_args()

    try:
        if args.check:
            check(args.source)
        else:
            skills = load_skills(args.source)
            generate(skills, args.claude_out, args.codex_out)
            print(f"✓ Generated {len(skills)} skill(s) for Claude and Codex")
    except ValueError as exc:
        print(f"❌ {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
