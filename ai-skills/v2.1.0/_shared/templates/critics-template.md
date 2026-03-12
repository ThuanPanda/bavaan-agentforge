# CRITICS Skill Template
## Copy this when creating a new skill file

```markdown
---
name: bavaan-{role}-{task-name}
description: >
  [What it does in 1-2 sentences.]
  Triggers on: "[phrase 1]", "[phrase 2]", "[phrase 3]",
  [any auto-trigger conditions like PR opened, ticket status changed].
metadata:
  author: bavaan-engineering
  version: 2.1.0
  category: [orchestration|product-management|architecture|backend-execution|frontend-execution|infrastructure|quality-assurance]
  mcp-server: [comma-separated: monday, github, figma, microsoft-graph, sharepoint, prisma]
  stack: [relevant tech stack]
---

# [Skill Name]

## CONSTRAINTS
- [Hard rule 1 — specific, never vague. Use MUST/NEVER/ALWAYS]
- [Hard rule 2]
- [Hard rule 3 — include multi-tenant rule if applicable]

## ROLE
[Job title], [X]+ years [specific domain]. Expert in [specific
technologies/patterns relevant to this skill].

## INPUTS
- {input_name_1} via [MCP Server] ([how it's fetched])
- {input_name_2} via [MCP Server] ([how it's fetched])

## TOOLS
[Tool 1], [Tool 2], [Tool 3]

## INSTRUCTIONS
[For each sub-skill, add a ### heading]

### For [Task Name] ([filename].md):
1. [Specific, numbered action step]
2. [Step 2 — reference {input_variables} explicitly]
3. [Step 3 — use code blocks for code patterns]
4. [Step 4 — specify output format]

## CONCLUSIONS
Output: [exact files/artifacts produced, format, location]

## SOLUTIONS
- [{condition}] → [action / fallback / escalation path]
- [{error state}] → [specific fix or who to notify]
```

---

## Checklist before publishing a new skill

- [ ] name is kebab-case, no spaces, no capitals
- [ ] description includes WHAT + WHEN + trigger phrases
- [ ] description under 1024 characters
- [ ] no XML angle brackets (< >) anywhere in frontmatter
- [ ] CONSTRAINTS use MUST/NEVER/ALWAYS (not "should")
- [ ] INPUTS reference specific MCP-fetched variables
- [ ] INSTRUCTIONS are numbered, actionable steps
- [ ] CONCLUSIONS define exact output format
- [ ] SOLUTIONS cover common error paths
- [ ] Tested: triggers on 3 relevant phrases
- [ ] Tested: does NOT trigger on 2 unrelated phrases
