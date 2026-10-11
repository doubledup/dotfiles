---
paths:
    - "**/.claude/**"
    - "**/claude/**"
    - "**/CLAUDE.md"
    - "**/CLAUDE.local.md"
    - "**/.mcp.json"
---

# Claude Code Config

- To guarantee a subagent has a skill's content, use the `skills:` frontmatter field, which injects
  the full skill body at startup. Not `Skill` in `tools` (grants every skill, and invocation is
  discretionary/best-effort), not a hook, not duplicating the content into the prompt
- Anything behind an instruction to load, fetch, or invoke is model-mediated. If it must always
  apply, it must always be in context
