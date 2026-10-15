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
- Verify fields against the reference before writing them, not from memory: config is version-gated,
  and a wrong-but-valid choice passes `just check`. Settings:
  https://code.claude.com/docs/en/settings; agents:
  https://code.claude.com/docs/en/sub-agents#supported-frontmatter-fields; skills and commands:
  https://code.claude.com/docs/en/skills#frontmatter-reference; hooks:
  https://code.claude.com/docs/en/hooks; `.mcp.json`: https://code.claude.com/docs/en/mcp
