#!/usr/bin/env python3
"""Claude/Codex hook helpers for Obsidian workflow integration."""

from __future__ import annotations

import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


VAULT_DIR = Path(
    os.environ.get("OBSIDIAN_VAULT_DIR", str(Path.home() / ".knowledge"))
).expanduser()
TASKS_FILE = VAULT_DIR / "tasks.md"
LESSONS_FILE = VAULT_DIR / "learning" / "lessons.md"
ACHIEVEMENTS_FILE = VAULT_DIR / "career" / "achievement-log.md"
ACHIEVEMENT_INBOX_FILE = VAULT_DIR / "career" / "achievement-inbox.md"
ACTIVITY_LOG_FILE = VAULT_DIR / "setup" / "claude-activity-log.md"
CODEX_ACTIVITY_LOG_FILE = VAULT_DIR / "setup" / "codex-activity-log.md"
DEFAULT_ACTIVITY_LOG = """# Claude Activity Log

Auto-generated from Claude hooks. Use this as raw session telemetry, then
promote meaningful outcomes into `tasks.md`, `learning/lessons.md`, and
`career/achievement-log.md`.

## Entries
"""
DEFAULT_CODEX_ACTIVITY_LOG = """# Codex Activity Log

Auto-generated from Codex notifications. Use this as raw session telemetry, then
promote meaningful outcomes into `tasks.md`, `learning/lessons.md`, and
`career/achievement-log.md`.

## Entries
"""
DEFAULT_ACHIEVEMENT_INBOX = """# Achievement Inbox

Auto-captured achievement candidates from Claude task completions and
Codex notify events.
Only intentionally marked wins are captured here (for example:
`achievement: reduced build time by 42%`).
Promote polished, evidence-backed entries into `career/achievement-log.md`.

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


def normalize_whitespace(value: str) -> str:
    return " ".join(value.split())


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

    entry_parts = [utc_now_iso(), f"event={event}"]
    if session_id:
        entry_parts.append(f"session={session_id}")
    if details:
        entry_parts.append(normalize_whitespace(details))

    entries.append("- " + " | ".join(entry_parts))
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


def missing_required_files() -> list[Path]:
    required = [TASKS_FILE, LESSONS_FILE, ACHIEVEMENTS_FILE]
    return [path for path in required if not path.exists()]


def build_obsidian_context() -> str:
    tasks_md = read_text(TASKS_FILE)
    lessons_md = read_text(LESSONS_FILE)
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
            "Primary files: "
            f"{TASKS_FILE}, {LESSONS_FILE}, {ACHIEVEMENTS_FILE}"
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
    if cwd:
        append_activity_entry(
            "session_start",
            f"cwd={short_path(Path(cwd))}",
            session_id,
        )
    else:
        append_activity_entry("session_start", "session started", session_id)

    missing = missing_required_files()
    if not VAULT_DIR.exists() or missing:
        missing_label = ", ".join(str(path) for path in missing) if missing else str(VAULT_DIR)
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
                "additionalContext": build_obsidian_context(),
            },
        }
    )


def emit_pre_compact() -> None:
    if not VAULT_DIR.exists():
        return

    print_json(
        {
            "suppressOutput": True,
            "hookSpecificOutput": {
                "hookEventName": "PreCompact",
                "additionalContext": build_obsidian_context(),
            },
        }
    )


def emit_session_end(payload: dict[str, Any]) -> None:
    append_activity_entry("session_end", "session ended", extract_session_id(payload))

    if not VAULT_DIR.exists():
        return

    print_json(
        {
            "systemMessage": (
                "Before ending, update ~/.knowledge/tasks.md with progress and "
                "~/.knowledge/learning/lessons.md with any new rules."
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
        append_activity_entry("file_edit", f"{tool_name} {short_path(file_path)}", session_id)
    else:
        append_activity_entry("file_edit", f"{tool_name} (path unavailable)", session_id)
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


def append_achievement_candidate(candidate: str, session_id: str | None = None) -> None:
    append_markdown_activity_entry(
        ACHIEVEMENT_INBOX_FILE,
        DEFAULT_ACHIEVEMENT_INBOX,
        "candidate",
        "outcome=" + candidate,
        session_id,
    )


def emit_task_completed(payload: dict[str, Any]) -> None:
    task_label = extract_task_label(payload)
    session_id = extract_session_id(payload)
    append_activity_entry(
        "task_completed",
        task_label,
        session_id,
    )

    candidate = extract_achievement_candidate(task_label)
    if candidate:
        append_achievement_candidate(candidate, session_id)
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
        for item in input_messages:
            if not isinstance(item, str):
                continue
            candidate = extract_achievement_candidate_from_multiline(item.strip())
            if candidate:
                return candidate

    assistant_message = extract_codex_assistant_message(payload)
    if assistant_message:
        candidate = extract_achievement_candidate_from_multiline(assistant_message)
        if candidate:
            return candidate

    return None


def emit_codex_notify(payload: dict[str, Any]) -> None:
    event_type = extract_codex_string(payload, "type") or "agent-turn-complete"
    thread_id = extract_codex_thread_id(payload)

    details_parts: list[str] = []

    cwd = extract_codex_string(payload, "cwd")
    if cwd:
        details_parts.append(f"cwd={short_path(Path(cwd))}")

    user_messages = extract_codex_messages(payload)
    if user_messages:
        details_parts.append("user=" + truncate(user_messages, 220))

    assistant_message = extract_codex_assistant_message(payload)
    if assistant_message:
        details_parts.append("assistant=" + truncate(assistant_message, 220))

    details = " | ".join(details_parts) if details_parts else "notification received"

    append_codex_activity_entry(
        event_type.replace("-", "_"),
        details,
        thread_id,
    )

    candidate = extract_codex_achievement_candidate(payload)
    if candidate:
        append_achievement_candidate(candidate, thread_id)


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
        emit_pre_compact()
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
