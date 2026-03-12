# Changelog — bavaan-agentforge

All notable changes to the AI Skill Base are documented here.
Format: [version] · Date · Author · Summary

---

## [v1.0.0] — 2025-Q3 — Current

### Added
- QA Agent: `multi-tenant-seeder.md` — factory functions for tenant test isolation
- QA Agent: `ac-validator.md` — maps test results to ACs, auto-marks Done on Monday
- Backend Agent: `nestjs-tenant-aware-service.md` — full CRITICS template for tenant isolation
- DevOps Agent: `husky-setup.md` — pre-commit hook configuration skill
- PM Agent: `release-notes-drafter.md` — post-merge auto-draft from PRs + Monday items
- Orchestrator: `intent-analyzer.md` — improved intent parsing with task-type classification
- All agents: Microsoft Graph MCP added (replaces raw Outlook MCP)
- All agents: Prisma/DB MCP added for schema introspection

### Changed
- Orchestrator model upgraded: gpt-4 → claude-opus-4
- All role agents: claude-sonnet-3.5 → claude-sonnet-4
- Backend skills: Husky integration added to unit-test-runner.md
- Architect Agent: pr-arch-reviewer.md extended with sync-blocking anti-pattern checks
- QA Agent: playwright-e2e-generator.md updated to use Page Object Model pattern

### Fixed
- Backend: Fixed tenantId enforcement gap in findUnique queries
- Frontend: Fixed 'use client' directive detection in nested components
- DevOps: Playwright timeout increased to 30s for Next.js hydration

---

## [v2.0.0] — 2025-Q2

### Added
- Full CRITICS framework applied to all skill files
- Progressive Disclosure 3-level system implemented
- Figma MCP integration (node ID based queries)
- GitHub Actions qa-gate.yml workflow
- Architect Agent: pr-arch-reviewer.md
- Multi-tenant tenantId enforcement in all backend skills

### Changed
- Skill files restructured from prompt templates → CRITICS format
- Context loading: bulk loading → intent-routed MCP queries
- Token cost reduced ~65% vs v1.x

---

## [v1.2.0] — 2025-Q1

### Added
- QA Agent: playwright-e2e-generator.md (first version)
- Backend: code-standard-checker.md
- DevOps: playwright-pr-runner.md

### Changed
- PM skills: improved Epic + Story templates

---

## [v1.0.0] — 2024-Q4 — Initial Release

- 7 agents defined
- Basic skill files per role
- Monday.com + GitHub MCP integration
- Basic CI/CD pipeline

---

*To upgrade: update ai-skills/ folder in Claude.ai Settings > Skills*
