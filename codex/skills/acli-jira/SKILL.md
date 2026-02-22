---
name: acli-jira
description: Use when working with Jira tickets via Atlassian CLI (acli). Provides the correct issue retrieval syntax and a minimal, reliable workflow.
metadata:
    short-description: Reliable acli Jira ticket retrieval
---

# acli-jira

Use this skill when fetching, inspecting, or summarizing Jira tickets with `acli`.

## Core commands

- View ticket: `acli jira workitem view <KEY>`
- JSON output: `acli jira workitem view <KEY> --json`
- Minimal fields: `acli jira workitem view <KEY> --json --fields "summary,status,assignee,description"`
- Full fields (only when needed): `acli jira workitem view <KEY> --json --fields "*all"`
- If key is unknown: `acli jira workitem search ...`

## Rules

- Use `acli jira workitem ...` for Jira tickets.
- Do not use `acli issue ...` in this environment.
- Default to minimal fields first; use `*all` only for deep metadata (for example linked PR data).

## Failure handling

1. Verify command surface if unsure:
    - `acli --help`
    - `acli jira --help`
    - `acli jira workitem --help`
2. Check auth when commands fail:
    - `acli jira auth status`
3. If permissions are insufficient, report the exact error and continue with available data.

## Suggested workflow

1. Fetch concise ticket details first.
2. Expand to JSON with minimal fields if structured parsing is needed.
3. Use `*all` only when deep links/metadata are required (then pivot to `gh` for PR details).
