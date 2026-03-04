#!/usr/bin/env python3
"""Claude/Codex hook helpers for Obsidian workflow integration."""

from __future__ import annotations

import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Literal


VAULT_DIR = Path(
    os.environ.get("OBSIDIAN_VAULT_DIR", str(Path.home() / ".knowledge"))
).expanduser()
ACHIEVEMENTS_FILE = VAULT_DIR / "career" / "achievement-log.md"
ACHIEVEMENT_INBOX_FILE = VAULT_DIR / "career" / "achievement-inbox.md"
ACTIVITY_LOG_FILE = VAULT_DIR / "setup" / "claude-activity-log.md"
CODEX_ACTIVITY_LOG_FILE = VAULT_DIR / "setup" / "codex-activity-log.md"
DEFAULT_ACTIVITY_LOG = """# Claude Activity Log

Auto-generated from Claude hooks as a human-readable session report stream.
Promote meaningful outcomes into repo-scoped `.claude/tasks.md` and
`.claude/lessons.md`, plus `career/achievement-log.md`.

Entry format:
- `YYYY-MM-DD HH:MM UTC — <Event> [session/thread]: <summary>`

## Entries
"""
DEFAULT_CODEX_ACTIVITY_LOG = """# Codex Activity Log

Auto-generated from Codex notifications as a human-readable turn report stream.
Promote meaningful outcomes into repo-scoped `.agent/tasks.md` and
`.agent/lessons.md`, plus `career/achievement-log.md`.

Entry format:
- `YYYY-MM-DD HH:MM UTC — <Event> [session/thread]: <summary>`

## Entries
"""
DEFAULT_REPO_TASKS_FILE = """# Active Tasks

Track active execution for this repository.

## In Progress

### YYYY-MM-DD | Context | Objective

- Status: planned | in_progress | blocked | done
- Scope:
- Checklist:
  - [ ] Item 1
  - [ ] Item 2
  - [ ] Item 3
- Verification:
  - Commands/tests run:
  - Expected behavior:
  - Actual behavior:
- Notes:

## Completed

### YYYY-MM-DD | Context | Objective

- Outcome:
- Verification summary:
- Follow-ups:
"""
DEFAULT_REPO_LESSONS_FILE = """# Lessons Learned

Capture repeatable lessons from repository-specific mistakes and rework.

## Entry Template

```md
### YYYY-MM-DD | Context
- Mistake:
- Signal:
- Root cause:
- New rule:
- Enforcement check:
```

## Entries
"""
DEFAULT_ACHIEVEMENT_INBOX = """# Achievement Inbox

Auto-captured achievement candidates from Claude task completions and
Codex notify events.
Only intentionally marked wins are captured here (for example:
`achievement: reduced build time by 42%`).
Promote polished, evidence-backed entries into `career/achievement-log.md`.
Entries are intentionally structured so they can be reviewed quickly and
promoted with minimal rewriting.

## Entries
"""


def parse_max_activity_entries() -> int:
    raw = os.environ.get(
        "OBSIDIAN_ACTIVITY_MAX_ENTRIES",
        os.environ.get("CLAUDE_OBSIDIAN_MAX_ACTIVITY_ENTRIES", "400"),
    )
    try:
        value = int(raw)
    except ValueError:
        return 400
    return min(max(value, 50), 5000)


MAX_ACTIVITY_ENTRIES = parse_max_activity_entries()


def parse_achievement_markers() -> tuple[str, ...]:
    raw = os.environ.get(
        "OBSIDIAN_ACHIEVEMENT_MARKERS",
        "achievement:,win:,impact:,[achievement]",
    )
    markers: list[str] = []
    for item in raw.split(","):
        marker = item.strip().lower()
        if marker and marker not in markers:
            markers.append(marker)
    if not markers:
        return ("achievement:",)
    return tuple(markers)


ACHIEVEMENT_MARKERS = parse_achievement_markers()


def read_hook_payload() -> dict[str, Any]:
    raw = sys.stdin.read()
    if not raw.strip():
        return {}
    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        return {}
    if isinstance(parsed, dict):
        return parsed
    return {}


def read_codex_notify_payload() -> dict[str, Any]:
    if len(sys.argv) < 3:
        return {}

    raw = sys.argv[2]
    if not raw.strip():
        return {}

    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        return {}

    if isinstance(parsed, dict):
        return parsed
    return {}


def print_json(payload: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(payload))


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except OSError:
        return ""


def truncate(text: str, limit: int = 1600) -> str:
    text = text.strip()
    if len(text) <= limit:
        return text
    return text[: limit - 1].rstrip() + "..."


def utc_now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def utc_now_label() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")


def normalize_whitespace(value: str) -> str:
    return " ".join(value.split())


def humanize_event(event: str) -> str:
    cleaned = normalize_whitespace(event.replace("_", " ").replace("-", " ").strip())
    if not cleaned:
        return "Activity"
    return cleaned[0].upper() + cleaned[1:]


def short_identifier(value: str, limit: int = 14) -> str:
    normalized = normalize_whitespace(value)
    if len(normalized) <= limit:
        return normalized
    return normalized[: limit - 3] + "..."


def short_path(path: Path) -> str:
    candidate = path.expanduser()
    try:
        candidate = candidate.resolve()
    except OSError:
        candidate = candidate.absolute()

    home = Path.home()
    try:
        return str(Path("~") / candidate.relative_to(home))
    except ValueError:
        return str(candidate)


def workspace_root_for_cwd(cwd_hint: str | None = None) -> Path:
    candidates = candidate_work_dirs(cwd_hint)
    if candidates:
        return candidates[0]
    return Path.home()

def candidate_work_dirs(cwd_hint: str | None = None) -> list[Path]:
    candidates: list[Path] = []
    raw_values: list[str] = []
    try:
        current_dir = Path.cwd()
    except OSError:
        current_dir = Path.home()

    if cwd_hint and cwd_hint.strip():
        raw_values.append(cwd_hint.strip())
    else:
        env_pwd = os.environ.get("PWD")
        if env_pwd and env_pwd.strip():
            raw_values.append(env_pwd.strip())
        raw_values.append(str(current_dir))

    seen: set[str] = set()
    for raw in raw_values:
        if raw in seen:
            continue
        seen.add(raw)
        path = Path(raw).expanduser()
        if not path.is_absolute():
            path = current_dir / path
        try:
            path = path.resolve()
        except OSError:
            path = path.absolute()
        if path.is_file():
            path = path.parent
        candidates.append(path)

    return candidates


def repo_root_for_cwd(cwd_hint: str | None = None) -> Path | None:
    for candidate in candidate_work_dirs(cwd_hint):
        for parent in (candidate, *candidate.parents):
            git_marker = parent / ".git"
            if git_marker.exists():
                return parent
    return None


def workflow_root_for_cwd(cwd_hint: str | None = None) -> tuple[Path, bool]:
    repo_root = repo_root_for_cwd(cwd_hint)
    if repo_root is not None:
        return repo_root, True
    return workspace_root_for_cwd(cwd_hint), False


MemoryDir = Literal[".claude", ".agent"]
WORKFLOW_FILE_DEFAULTS: dict[str, str] = {
    "tasks.md": DEFAULT_REPO_TASKS_FILE,
    "lessons.md": DEFAULT_REPO_LESSONS_FILE,
}


def read_text_optional(path: Path) -> str | None:
    try:
        return path.read_text(encoding="utf-8")
    except OSError:
        return None


def write_text(path: Path, content: str) -> None:
    try:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
    except OSError:
        return


def file_mtime_ns(path: Path) -> int:
    try:
        return path.stat().st_mtime_ns
    except OSError:
        return -1


def remove_file_like(path: Path) -> bool:
    if not path.exists() and not path.is_symlink():
        return True
    if path.is_dir() and not path.is_symlink():
        return False
    try:
        path.unlink()
    except OSError:
        return False
    return True


def create_relative_symlink(link_path: Path, target_path: Path) -> bool:
    try:
        link_path.parent.mkdir(parents=True, exist_ok=True)
        relative_target = os.path.relpath(target_path, start=link_path.parent)
    except OSError:
        return False

    if link_path.is_symlink():
        try:
            if os.readlink(link_path) == relative_target:
                return True
        except OSError:
            pass

    if not remove_file_like(link_path):
        return False

    try:
        link_path.symlink_to(relative_target)
    except OSError:
        return False
    return True


def files_share_target(left: Path, right: Path) -> bool:
    try:
        return left.is_file() and right.is_file() and left.samefile(right)
    except OSError:
        return False


def choose_source_markdown(
    primary: Path,
    secondary: Path,
    default_content: str,
) -> tuple[Path, str]:
    primary_exists = primary.is_file()
    secondary_exists = secondary.is_file()

    if not primary_exists and not secondary_exists:
        return primary, default_content

    if primary_exists and not secondary_exists:
        return primary, read_text_optional(primary) or default_content

    if secondary_exists and not primary_exists:
        return secondary, read_text_optional(secondary) or default_content

    primary_content = read_text_optional(primary)
    secondary_content = read_text_optional(secondary)
    if primary_content is None and secondary_content is None:
        return primary, default_content
    if primary_content is None:
        return secondary, secondary_content or default_content
    if secondary_content is None:
        return primary, primary_content
    if primary_content == secondary_content:
        return primary, primary_content

    if file_mtime_ns(primary) >= file_mtime_ns(secondary):
        return primary, primary_content
    return secondary, secondary_content


def sync_markdown_pair(primary: Path, secondary: Path, default_content: str) -> None:
    for path in (primary, secondary):
        if path.is_symlink() and not path.exists():
            remove_file_like(path)

    if files_share_target(primary, secondary):
        return

    source_path, source_content = choose_source_markdown(primary, secondary, default_content)
    mirror_path = secondary if source_path == primary else primary

    if source_path.is_symlink():
        if not remove_file_like(source_path):
            return
    write_text(source_path, source_content)

    if files_share_target(source_path, mirror_path):
        return

    if create_relative_symlink(mirror_path, source_path):
        return

    if mirror_path.is_symlink() and not remove_file_like(mirror_path):
        return
    write_text(mirror_path, source_content)


def sync_workflow_memory_dirs(workflow_root: Path, *, preferred_memory_dir: MemoryDir) -> None:
    secondary_memory_dir: MemoryDir
    if preferred_memory_dir == ".claude":
        secondary_memory_dir = ".agent"
    else:
        secondary_memory_dir = ".claude"

    for filename, default_content in WORKFLOW_FILE_DEFAULTS.items():
        preferred_file = workflow_root / preferred_memory_dir / filename
        secondary_file = workflow_root / secondary_memory_dir / filename
        sync_markdown_pair(preferred_file, secondary_file, default_content)


def workflow_files_for_cwd(
    cwd_hint: str | None = None,
    *,
    memory_dir: MemoryDir,
    create_repo_files: bool = False,
) -> tuple[Path, Path, Path, bool]:
    workflow_root, is_repo_root = workflow_root_for_cwd(cwd_hint)
    tasks_file = workflow_root / memory_dir / "tasks.md"
    lessons_file = workflow_root / memory_dir / "lessons.md"

    if create_repo_files:
        sync_workflow_memory_dirs(workflow_root, preferred_memory_dir=memory_dir)

    return tasks_file, lessons_file, workflow_root, is_repo_root


def ensure_workflow_files(cwd_hint: str | None, memory_dir: MemoryDir) -> None:
    """Create workflow files if they don't exist (side-effect only)."""
    workflow_files_for_cwd(cwd_hint, memory_dir=memory_dir, create_repo_files=True)


def ensure_markdown_log_exists(path: Path, default_content: str) -> None:
    if path.exists():
        return

    try:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(default_content, encoding="utf-8")
    except OSError:
        return


def split_activity_log(markdown: str, default_content: str) -> tuple[list[str], list[str]]:
    lines = markdown.splitlines()
    if "## Entries" in lines:
        split_index = lines.index("## Entries")
        preamble = lines[: split_index + 1]
        entries = [line for line in lines[split_index + 1 :] if line.startswith("- ")]
        return preamble, entries

    preamble = default_content.rstrip("\n").splitlines()
    entries = [line for line in lines if line.startswith("- ")]
    return preamble, entries


def append_markdown_activity_entry(
    path: Path,
    default_content: str,
    event: str,
    details: str,
    session_id: str | None = None,
) -> None:
    ensure_markdown_log_exists(path, default_content)

    existing = read_text(path)
    preamble, entries = split_activity_log(existing, default_content)

    entry = f"- {utc_now_label()} — {humanize_event(event)}"
    if session_id:
        entry += f" [{short_identifier(session_id)}]"
    if details:
        entry += ": " + normalize_whitespace(details)

    entries.append(entry)
    entries = entries[-MAX_ACTIVITY_ENTRIES:]

    content = "\n".join(preamble + [""] + entries + [""])
    try:
        path.write_text(content, encoding="utf-8")
    except OSError:
        return


def append_activity_entry(event: str, details: str, session_id: str | None = None) -> None:
    append_markdown_activity_entry(
        ACTIVITY_LOG_FILE,
        DEFAULT_ACTIVITY_LOG,
        event,
        details,
        session_id,
    )


def append_codex_activity_entry(event: str, details: str, thread_id: str | None = None) -> None:
    append_markdown_activity_entry(
        CODEX_ACTIVITY_LOG_FILE,
        DEFAULT_CODEX_ACTIVITY_LOG,
        event,
        details,
        thread_id,
    )


def recent_markdown_activity_entries(
    path: Path,
    default_content: str,
    limit: int = 6,
) -> list[str]:
    text = read_text(path)
    if not text:
        return []

    _, entries = split_activity_log(text, default_content)
    return entries[-limit:]


def recent_activity_entries(limit: int = 6) -> list[str]:
    return recent_markdown_activity_entries(ACTIVITY_LOG_FILE, DEFAULT_ACTIVITY_LOG, limit)


def recent_codex_activity_entries(limit: int = 6) -> list[str]:
    return recent_markdown_activity_entries(
        CODEX_ACTIVITY_LOG_FILE,
        DEFAULT_CODEX_ACTIVITY_LOG,
        limit,
    )


def extract_markdown_section(markdown: str, heading: str) -> str:
    lines = markdown.splitlines()
    result: list[str] = []
    capturing = False

    for line in lines:
        if line.strip() == heading:
            capturing = True
            continue
        if capturing and line.startswith("## "):
            break
        if capturing:
            result.append(line)

    return "\n".join(result).strip()


def latest_level3_heading(markdown: str) -> str:
    for line in reversed(markdown.splitlines()):
        if line.startswith("### "):
            return line.strip()
    return ""


def build_obsidian_context(
    cwd_hint: str | None = None,
    *,
    resolved: tuple[Path, Path, Path, bool] | None = None,
) -> str:
    if resolved is None:
        resolved = workflow_files_for_cwd(
            cwd_hint, memory_dir=".claude", create_repo_files=True,
        )
    tasks_file, lessons_file, workflow_root, is_repo_root = resolved
    tasks_md = read_text(tasks_file)
    lessons_md = read_text(lessons_file)
    achievements_md = read_text(ACHIEVEMENTS_FILE)
    recent_activity = recent_activity_entries(6)
    recent_codex_activity = recent_codex_activity_entries(4)

    in_progress = extract_markdown_section(tasks_md, "## In Progress")
    latest_lesson = latest_level3_heading(lessons_md)
    latest_achievement = latest_level3_heading(achievements_md)

    context = [
        f"Obsidian vault path: {VAULT_DIR}",
        "Use Obsidian workflow notes for continuity across sessions.",
        (
            "Project workflow root: "
            f"{short_path(workflow_root)} ({'git repo' if is_repo_root else 'workspace'})"
        ),
        (
            "Primary files: "
            f"{tasks_file}, {lessons_file}, {ACHIEVEMENTS_FILE}"
        ),
    ]

    if in_progress:
        context.append("Current tasks snapshot:\n" + truncate(in_progress, 1200))
    else:
        context.append("Current tasks snapshot: no in-progress entries recorded.")

    if latest_lesson:
        context.append(f"Most recent lesson entry: {latest_lesson}")
    if latest_achievement:
        context.append(f"Most recent achievement entry: {latest_achievement}")
    if recent_activity:
        context.append("Recent Claude activity:\n" + "\n".join(recent_activity))
    if recent_codex_activity:
        context.append("Recent Codex activity:\n" + "\n".join(recent_codex_activity))

    return "\n\n".join(context)


def extract_session_id(payload: dict[str, Any]) -> str | None:
    for key in ("session_id", "sessionId"):
        value = payload.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    return None


def extract_cwd(payload: dict[str, Any]) -> str | None:
    value = payload.get("cwd")
    if isinstance(value, str) and value.strip():
        return value.strip()
    return None


def emit_session_start(payload: dict[str, Any]) -> None:
    session_id = extract_session_id(payload)
    cwd = extract_cwd(payload)
    resolved = workflow_files_for_cwd(cwd, memory_dir=".claude", create_repo_files=True)
    tasks_file, lessons_file, _, _ = resolved
    if cwd:
        append_activity_entry(
            "session_start",
            f"Started in {short_path(Path(cwd))}.",
            session_id,
        )
    else:
        append_activity_entry("session_start", "Session started.", session_id)

    required = [tasks_file, lessons_file, ACHIEVEMENTS_FILE]
    missing = [p for p in required if not p.exists()]
    if not VAULT_DIR.exists() or missing:
        missing_label = (
            ", ".join(short_path(path) for path in missing)
            if missing
            else short_path(VAULT_DIR)
        )
        print_json(
            {
                "systemMessage": (
                    "Obsidian workflow files are missing: "
                    f"{missing_label}. Run `make obsidian` from ~/.dotfiles."
                ),
                "suppressOutput": True,
            }
        )
        return

    print_json(
        {
            "suppressOutput": True,
            "hookSpecificOutput": {
                "hookEventName": "SessionStart",
                "additionalContext": build_obsidian_context(cwd, resolved=resolved),
            },
        }
    )


def emit_pre_compact(payload: dict[str, Any]) -> None:
    if not VAULT_DIR.exists():
        return

    cwd = extract_cwd(payload)
    # build_obsidian_context ensures workflow files exist via create_repo_files=True.
    print_json(
        {
            "suppressOutput": True,
            "hookSpecificOutput": {
                "hookEventName": "PreCompact",
                "additionalContext": build_obsidian_context(cwd),
            },
        }
    )


def emit_session_end(payload: dict[str, Any]) -> None:
    append_activity_entry("session_end", "Session ended.", extract_session_id(payload))

    if not VAULT_DIR.exists():
        return

    cwd = extract_cwd(payload)
    tasks_file, lessons_file, _, _ = workflow_files_for_cwd(
        cwd, memory_dir=".claude",
    )

    print_json(
            {
                "systemMessage": (
                    "Before ending, add a concise human-readable report to "
                    f"{short_path(tasks_file)} (outcome, verification, follow-ups) "
                    "and capture any new rules in "
                    f"{short_path(lessons_file)}."
                ),
                "suppressOutput": True,
            }
        )


def path_from_payload(payload: dict[str, Any]) -> Path | None:
    tool_input = payload.get("tool_input")
    if isinstance(tool_input, dict):
        file_path = tool_input.get("file_path")
        if isinstance(file_path, str) and file_path:
            return Path(file_path).expanduser()

    tool_response = payload.get("tool_response")
    if isinstance(tool_response, dict):
        file_path = tool_response.get("filePath")
        if isinstance(file_path, str) and file_path:
            return Path(file_path).expanduser()

    return None


def tool_name_from_payload(payload: dict[str, Any]) -> str:
    value = payload.get("tool_name")
    if isinstance(value, str) and value.strip():
        return value.strip()
    return "Write|Edit"


def path_is_in_vault(path: Path) -> bool:
    absolute_path = path.absolute()
    absolute_vault = VAULT_DIR.absolute()

    try:
        if absolute_path.is_relative_to(absolute_vault):
            return True
    except AttributeError:
        if str(absolute_path).startswith(str(absolute_vault) + os.sep):
            return True
    except ValueError:
        pass

    try:
        resolved_path = absolute_path.resolve()
        resolved_vault = VAULT_DIR.resolve()
    except OSError:
        return False

    try:
        return resolved_path.is_relative_to(resolved_vault)
    except AttributeError:
        return str(resolved_path).startswith(str(resolved_vault) + os.sep)
    except ValueError:
        return False


def emit_post_tool_write_edit(payload: dict[str, Any]) -> None:
    file_path = path_from_payload(payload)
    session_id = extract_session_id(payload)
    tool_name = tool_name_from_payload(payload)

    if file_path:
        append_activity_entry(
            "file_edit",
            f"{tool_name} edited {short_path(file_path)}.",
            session_id,
        )
    else:
        append_activity_entry(
            "file_edit",
            f"{tool_name} edited a file (path unavailable).",
            session_id,
        )
        return

    if not path_is_in_vault(file_path):
        return

    absolute_path = file_path.absolute()
    absolute_vault = VAULT_DIR.absolute()

    try:
        relative = absolute_path.relative_to(absolute_vault)
    except ValueError:
        relative = absolute_path.resolve().relative_to(VAULT_DIR.resolve())

    print_json(
        {
            "suppressOutput": True,
            "systemMessage": f"Obsidian note updated: ~/.knowledge/{relative}",
        }
    )


def extract_task_label(payload: dict[str, Any]) -> str:
    direct_fields = ("task", "task_title", "title", "objective", "summary", "description")
    for field in direct_fields:
        value = payload.get(field)
        if isinstance(value, str) and value.strip():
            return value.strip()
        if isinstance(value, dict):
            for nested in ("title", "name", "objective", "summary", "description"):
                nested_value = value.get(nested)
                if isinstance(nested_value, str) and nested_value.strip():
                    return nested_value.strip()

    user_message = payload.get("user_message")
    if isinstance(user_message, str) and user_message.strip():
        return user_message.strip()

    return "Task completed"


def extract_achievement_candidate(task_label: str) -> str | None:
    normalized = normalize_whitespace(task_label.strip())
    lowered = normalized.lower()

    for marker in ACHIEVEMENT_MARKERS:
        if lowered.startswith(marker):
            candidate = normalize_whitespace(normalized[len(marker) :].strip(" -:|"))
            if candidate:
                return candidate
            return None
    return None


def extract_achievement_candidate_from_multiline(text: str) -> str | None:
    candidate = extract_achievement_candidate(text)
    if candidate:
        return candidate

    for line in text.splitlines():
        candidate = extract_achievement_candidate(line)
        if candidate:
            return candidate
    return None


def latest_nonempty_message(messages: list[Any]) -> str:
    for item in reversed(messages):
        if isinstance(item, str) and item.strip():
            return item.strip()
    return ""


def append_achievement_candidate(
    candidate: str,
    session_id: str | None = None,
    source_label: str = "Claude task completed",
) -> None:
    ensure_markdown_log_exists(ACHIEVEMENT_INBOX_FILE, DEFAULT_ACHIEVEMENT_INBOX)
    existing = read_text(ACHIEVEMENT_INBOX_FILE).rstrip()

    if "## Entries" not in existing.splitlines():
        if existing:
            existing = existing + "\n\n## Entries"
        else:
            existing = DEFAULT_ACHIEVEMENT_INBOX.rstrip()

    source = source_label
    if session_id:
        source += f" ({short_identifier(session_id, 18)})"

    outcome_line = f"- Outcome: {candidate}"
    source_line = f"- Source: {source}"
    if outcome_line in existing and source_line in existing:
        return

    entry_lines = [
        f"### {utc_now_label()} | Candidate Achievement",
        outcome_line,
        source_line,
        "- Why this matters:",
        "- Evidence:",
        "- Promote to `career/achievement-log.md` after review.",
    ]

    content = existing + "\n\n" + "\n".join(entry_lines) + "\n"
    try:
        ACHIEVEMENT_INBOX_FILE.write_text(content, encoding="utf-8")
    except OSError:
        return


def emit_task_completed(payload: dict[str, Any]) -> None:
    task_label = extract_task_label(payload)
    session_id = extract_session_id(payload)
    append_activity_entry(
        "task_completed",
        truncate(normalize_whitespace(task_label), 320),
        session_id,
    )

    candidate = extract_achievement_candidate(task_label)
    if candidate:
        append_achievement_candidate(
            candidate,
            session_id,
            source_label="Claude task completed",
        )
        print_json(
            {
                "systemMessage": (
                    "Achievement candidate captured in "
                    "~/.knowledge/career/achievement-inbox.md"
                ),
                "suppressOutput": True,
            }
        )


def extract_codex_string(payload: dict[str, Any], field: str) -> str | None:
    value = payload.get(field)
    if isinstance(value, str) and value.strip():
        return value.strip()
    return None


def extract_codex_thread_id(payload: dict[str, Any]) -> str | None:
    return (
        extract_codex_string(payload, "thread-id")
        or extract_codex_string(payload, "thread_id")
        or extract_codex_string(payload, "session_id")
    )


def extract_codex_messages(payload: dict[str, Any]) -> str:
    value = payload.get("input-messages")
    if not isinstance(value, list):
        return ""

    messages = [item.strip() for item in value if isinstance(item, str) and item.strip()]
    if not messages:
        return ""
    return " / ".join(messages[:3])


def extract_codex_assistant_message(payload: dict[str, Any]) -> str:
    return extract_codex_string(payload, "last-assistant-message") or ""


def extract_codex_achievement_candidate(payload: dict[str, Any]) -> str | None:
    input_messages = payload.get("input-messages")
    if isinstance(input_messages, list):
        latest_message = latest_nonempty_message(input_messages)
        if latest_message:
            candidate = extract_achievement_candidate_from_multiline(latest_message)
            if candidate:
                return candidate

    user_message = extract_codex_string(payload, "user-message")
    if user_message:
        candidate = extract_achievement_candidate_from_multiline(user_message)
        if candidate:
            return candidate

    return None


def emit_codex_notify(payload: dict[str, Any]) -> None:
    event_type = extract_codex_string(payload, "type") or "agent-turn-complete"
    thread_id = extract_codex_thread_id(payload)

    details_parts: list[str] = []

    cwd = extract_codex_string(payload, "cwd")
    ensure_workflow_files(cwd, ".agent")
    if cwd:
        details_parts.append(f"Working directory: {short_path(Path(cwd))}.")

    user_messages = extract_codex_messages(payload)
    if user_messages:
        details_parts.append("User asked: " + truncate(user_messages, 220) + ".")

    assistant_message = extract_codex_assistant_message(payload)
    if assistant_message:
        details_parts.append("Assistant replied: " + truncate(assistant_message, 220) + ".")

    details = " ".join(details_parts) if details_parts else "Notification received."

    append_codex_activity_entry(
        event_type.replace("-", "_"),
        details,
        thread_id,
    )

    candidate = extract_codex_achievement_candidate(payload)
    if candidate:
        append_achievement_candidate(
            candidate,
            thread_id,
            source_label="Codex notify",
        )


def main() -> int:
    event = sys.argv[1] if len(sys.argv) > 1 else ""

    if event == "codex-notify":
        emit_codex_notify(read_codex_notify_payload())
        return 0

    payload = read_hook_payload()

    if event == "session-start":
        emit_session_start(payload)
        return 0
    if event == "pre-compact":
        emit_pre_compact(payload)
        return 0
    if event == "session-end":
        emit_session_end(payload)
        return 0
    if event == "post-tool-write-edit":
        emit_post_tool_write_edit(payload)
        return 0
    if event == "task-completed":
        emit_task_completed(payload)
        return 0

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
