# Atlassian CLI (`acli`) Guide

## Command structure

All Jira operations use `acli jira workitem <subcommand>`. `acli issue ...` is not valid.

## Viewing issues

```bash
acli jira workitem view GLUE-1587
acli jira workitem view GLUE-1587 --json --fields "summary,status,assignee,description"
```

## Searching issues

```bash
acli jira workitem search --jql "project = GLUE AND labels = CIMS" --json --fields "key,summary,issuetype,labels" --limit 10
```

## Creating issues

```bash
acli jira workitem create \
  --project GLUE \
  --type Task \
  --summary "Short summary here" \
  --description "Plain text or ADF JSON" \
  --label CIMS \
  --parent GLUE-1234 \
  --json
```

For rich descriptions, write ADF JSON to a file and use `--description-file path/to/file.json`.

Key flags: `--project`, `--type` (Task, Bug, Story, Epic), `--summary`, `--description` / `--description-file`, `--label` (repeatable), `--parent`, `--assignee`.

## Other useful subcommands

- `search` - JQL search (`--jql`, `--limit`, `--fields`, `--json`, `--csv`)
- `edit` - Update fields on existing issues
- `transition` - Move issue status
- `comment` - Add comments
- `assign` - Assign issues

## Tips

- Use `--json` for machine-readable output
- Use `--fields` to limit output and reduce noise
- ADF (Atlassian Document Format) descriptions render with full formatting (bold, lists, code blocks, links)
- The GLUE project uses labels like `CIMS`, `CIS`, `KYC`, `CPS`, `Glue-Scrum` to categorize work
