# Kiến Trúc Tổng Thể — AgentForge
## Intent-Routed MCP Architecture + CRITICS Versioned Prompt Registry
### v1.0.0 · Bavaan Engineering

---

## 1. Vấn đề cốt lõi

### Context Fragmentation → Token Bloat → Hallucination

Khi đội kỹ thuật chuyển sang AI-assisted workflow theo cách thông thường:

```
❌ ANTI-PATTERN (Naive AI approach)
─────────────────────────────────────────────────────────────
Input:  Monday ticket + Figma mock + Slack/Teams thread
      + Prisma schema + Coding standards + All skill files
      → dump tất cả vào LLM

Result: ~15,000+ tokens/request
        Attention bị dilute
        Output generic, non-compilable
        Vi phạm multi-tenant isolation
        Token cost không kiểm soát được
```

```
✅ AGENTFORGE (Intent-Routed approach)
─────────────────────────────────────────────────────────────
Input:  Developer: "ai-task start TICKET-123"

Step 1: Orchestrator phân tích intent → xác định task type
Step 2: MCP query CHỈ entities cần thiết:
        - Specific Monday Epic ID (không toàn bộ board)
        - Specific Figma node ID (không toàn file)
        - Exact Prisma schema file (không toàn DB)
Step 3: Inject vào đúng CRITICS Skill Executable
Step 4: Output compilable, standards-compliant, tenant-safe code

Result: ~2,500 tokens/request (giảm 65%)
        Scoped, role-specific context
        Compilable output, zero violations
```

---

## 2. Sơ đồ kiến trúc tổng thể

```
╔═══════════════════════════════════════════════════════════════════╗
║                   BAVAAN AI-FIRST ECOSYSTEM                       ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  ┌─────────────────── CONTEXT SOURCES ──────────────────────┐    ║
║  │  Monday.com   Figma      SharePoint  Microsoft Graph      │    ║
║  │  (Epics/ACs)  (Designs)  (Docs/ADRs) (Email + Teams)     │    ║
║  └──────────────────────┬───────────────────────────────────┘    ║
║                         │                                         ║
║  ┌──────────────────────▼───────────────────────────────────┐    ║
║  │          MCP INTEGRATION LAYER (6 servers)                │    ║
║  │  Intent-Routed: chỉ query specific entities, không bulk  │    ║
║  │  Monday GraphQL · GitHub REST · Figma node API           │    ║
║  │  MS Graph keyword · SharePoint REST · Prisma schema      │    ║
║  └──────────────────────┬───────────────────────────────────┘    ║
║                         │                                         ║
║  ┌──────────────────────▼───────────────────────────────────┐    ║
║  │        ORCHESTRATOR AGENT  (claude-opus-4)                │    ║
║  │  intent-analyzer → context-fetcher → task-router         │    ║
║  │  sla-monitor → conflict-resolver                         │    ║
║  └──┬──────────┬──────────┬──────────┬──────────┬───────────┘    ║
║     │          │          │          │          │                 ║
║  ┌──▼──┐  ┌───▼──┐  ┌───▼──┐  ┌───▼──┐  ┌───▼──┐  ┌────────┐  ║
║  │ PM  │  │ARCH  │  │ BE   │  │ FE   │  │DEVOPS│  │  QA    │  ║
║  │Agent│  │Agent │  │Agent │  │Agent │  │Agent │  │ Agent  │  ║
║  │     │  │      │  │      │  │      │  │      │  │        │  ║
║  │6    │  │5     │  │6     │  │6     │  │6     │  │7       │  ║
║  │skill│  │skill │  │skill │  │skill │  │skill │  │skills  │  ║
║  └──┬──┘  └───┬──┘  └───┬──┘  └───┬──┘  └───┬──┘  └───┬────┘  ║
║     └─────────┴──────────┴──────────┴──────────┴─────────┘       ║
║                          │                                        ║
║  ┌───────────────────────▼──────────────────────────────────┐    ║
║  │      VERSIONED SKILL BASE  bavaan-ai-skills/ (git repo)  │    ║
║  │                                                           │    ║
║  │  Level 1: YAML Frontmatter    (~150 tokens, always)      │    ║
║  │  Level 2: CRITICS Body        (~1,500 tokens, on-demand) │    ║
║  │  Level 3: references/ files   (only when needed)         │    ║
║  └──────────────────────────────────────────────────────────┘    ║
║                                                                   ║
║  ┌─────────────────── OUTPUT TARGETS ──────────────────────┐     ║
║  │  Monday.com   GitHub PR   SharePoint   MS Teams          │     ║
║  │  (stories)    (code/PR)   (docs/ADRs)  (notifications)  │     ║
║  └──────────────────────────────────────────────────────────┘    ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## 3. CRITICS Framework

Mọi skill executable đều theo cấu trúc CRITICS:

```
┌─────────────────────────────────────────────────────────────┐
│  C — CONSTRAINTS   Hard rules không bao giờ vi phạm         │
│                    VD: "tenantId MUST be in every query"     │
│                                                              │
│  R — ROLE          Senior persona + domain expertise         │
│                    VD: "Senior NestJS Backend Engineer       │
│                         specializing in multi-tenant arch"   │
│                                                              │
│  I — INPUTS        Explicit MCP-sourced inputs chỉ định     │
│                    VD: {monday_ticket_context} via MCP       │
│                        {prisma_schema_context} via GitHub MCP│
│                                                              │
│  T — TOOLS         Specific tools được phép dùng            │
│                    VD: GitHub Copilot, Prisma Studio, Nest CLI│
│                                                              │
│  I — INSTRUCTIONS  Numbered steps, actionable, deterministic │
│                    (code checks > language instructions)     │
│                                                              │
│  C — CONCLUSIONS   Expected output format, "definition done" │
│                    VD: "Output compilable service.ts + dto.ts│
│                         formatted with Prettier"             │
│                                                              │
│  S — SOLUTIONS     If/else error handling + escalation paths │
│                    VD: "If tenantId missing → throw          │
│                         UnauthorizedException"               │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Progressive Disclosure — Token Architecture

```
REQUEST: "ai-task start TICKET-456 — build user profile API"
              │
              ▼
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 1: YAML Frontmatter  (~150 tokens — always in prompt)│
│                                                              │
│  name: nestjs-tenant-aware-service                          │
│  description: "...triggers on: nestjs crud, backend story"  │
│                                                              │
│  → Orchestrator reads ALL level-1 frontmatters              │
│  → Decides: "this is backend task → load backend skill"     │
└──────────────────────────┬──────────────────────────────────┘
                           │ (skill relevant → load level 2)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 2: CRITICS Body  (~1,500 tokens — on-demand)         │
│                                                              │
│  ## CONSTRAINTS, ROLE, INPUTS, TOOLS, INSTRUCTIONS...       │
│                                                              │
│  → Full instructions for the specific task                  │
│  → Injected alongside MCP-fetched context                   │
└──────────────────────────┬──────────────────────────────────┘
                           │ (needs API patterns reference)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 3: references/ files  (only when explicitly needed)  │
│                                                              │
│  references/nestjs-patterns.md                              │
│  references/prisma-multi-tenant-examples.md                 │
│                                                              │
│  → Agent navigates only when instructions say to            │
└─────────────────────────────────────────────────────────────┘

COMPARISON:
  Bulk loading:    ~15,000 tokens → diluted → generic output
  Progressive:     ~2,500 tokens  → focused → compilable output
  Reduction:       ~65–75%
```

---

## 5. Developer Workflow — Phase A (Local)

```
1. Developer: ai-task start TICKET-123
         │
2. Orchestrator (intent-analyzer.md)
   ├── Parse request type: "backend service"
   ├── MCP: Monday → fetch TICKET-123 Epic + ACs (GraphQL)
   ├── MCP: GitHub → fetch relevant Prisma schema file
   └── Route: Backend Agent + nestjs-tenant-aware-service.md
         │
3. Backend Agent generates:
   ├── service.ts (with tenantId on all queries)
   ├── dto.ts (with class-validator decorators)
   └── service.spec.ts (Jest unit tests)
         │
4. Husky Pre-commit Hook:
   ├── code-standard-checker.md → NestJS boundaries, Prettier
   ├── unit-test-runner.md → Jest
   └── FAIL? → AI generates fix diff → developer applies → retry
         │
5. git commit ✓  (only when all hooks pass)
```

---

## 6. Developer Workflow — Phase B (Pull Request)

```
git push + PR opened
         │
1. GitHub Actions: .github/workflows/qa-gate.yml
         │
2. QA Agent (playwright-pr-runner.md):
   ├── GitHub MCP → fetch PR diff
   ├── Monday MCP → fetch linked Epic ACs
   ├── Generate Playwright E2E specs (POM + tenant factories)
   ├── Seed multi-tenant test DB (tenant-001, tenant-002)
   └── Run Playwright headless
         │
   ├── FAIL:
   │   ├── Block merge (GitHub status check = FAILED)
   │   ├── Post failure summary on PR comment
   │   └── Monday MCP → create bug item with screenshot
   │
   └── PASS:
           │
3. Architect Agent (pr-arch-reviewer.md):
   ├── Check: synchronous inter-service blocking?
   ├── Check: tenantId on all Prisma queries?
   ├── Check: NestJS module boundaries respected?
   └── Add PR comment: "Architecture: APPROVED / ISSUES FOUND"
           │
4. PM Agent (release-notes-drafter.md):
   ├── Draft release notes from PR + Monday items
   ├── Push to SharePoint
   └── Update Monday linked story status
           │
5. MERGE APPROVED ✓
```

---

## 7. Multi-Tenant Security Architecture

```
TIER 1: Skill-level enforcement (in CONSTRAINTS section)
─────────────────────────────────────────────────────────
Every backend skill CONSTRAINTS includes:
  "MUST include tenantId in every Prisma read/write.
   If tenantId missing from JWT → throw UnauthorizedException
   BEFORE any database operation."

TIER 2: Code pattern enforcement (in INSTRUCTIONS section)
─────────────────────────────────────────────────────────
Every findMany:
  prisma.resource.findMany({ where: { tenantId: ctx.user.tenantId } })

Every create:
  prisma.resource.create({ data: { ...dto, tenantId: ctx.user.tenantId } })

Every findUnique:
  const record = await prisma.resource.findUnique({ where: { id } })
  if (record.tenantId !== ctx.user.tenantId) throw new ForbiddenException()

TIER 3: Pre-commit hook enforcement (code-standard-checker.md)
─────────────────────────────────────────────────────────────
Script scans staged files:
  grep "prisma\." → verify tenantId present
  grep "findMany\|findFirst\|findUnique" → check where clause
  FAIL → block commit + output violation list

TIER 4: PR-level enforcement (pr-arch-reviewer.md)
─────────────────────────────────────────────────────────────
Architect Agent reviews every PR diff:
  Flags any Prisma query without tenantId
  Blocks merge until fixed
```

---

## 8. MCP Integration Specification

```
┌──────────────┬─────────────────────────┬────────────────────────────┬────────────────┐
│ MCP Server   │ Query Pattern            │ What is fetched            │ Used by        │
├──────────────┼─────────────────────────┼────────────────────────────┼────────────────┤
│ Monday.com   │ GraphQL by Epic ID       │ Specific Epic + ACs        │ PM, QA, Orch.  │
│ GitHub       │ REST by file path/PR ID  │ Specific schema file, diff │ All agents     │
│ Figma        │ REST by node ID          │ Specific component props   │ FE, Architect  │
│ MS Graph     │ REST by keyword + date   │ Email/Teams snippets       │ PM, Orch.      │
│ SharePoint   │ REST by document path    │ Specific PRD/ADR file      │ PM, Arch., DO  │
│ Prisma/DB    │ Schema introspection     │ Specific model definition  │ BE, Architect  │
└──────────────┴─────────────────────────┴────────────────────────────┴────────────────┘
```

---

## 9. Agent Model & Role Matrix

```
┌─────────────────┬──────────────┬──────────────────────────────────────┬──────────┐
│ Agent           │ Model        │ Primary responsibility                │ Skills   │
├─────────────────┼──────────────┼──────────────────────────────────────┼──────────┤
│ Orchestrator    │ opus-4       │ Intent routing, context fetching      │ 5        │
│ PM Agent        │ sonnet-4     │ Epics, stories, ACs, reports          │ 6        │
│ Architect Agent │ sonnet-4     │ Design, ADRs, API contracts, PR review│ 5        │
│ Backend Agent   │ sonnet-4     │ NestJS services, Prisma, DTOs         │ 6        │
│ Frontend Agent  │ sonnet-4     │ Next.js components, Figma-to-code     │ 6        │
│ DevOps Agent    │ sonnet-4     │ CI/CD, Playwright gate, IaC           │ 6        │
│ QA Agent        │ sonnet-4     │ Playwright E2E, test cases, AC audit  │ 7        │
└─────────────────┴──────────────┴──────────────────────────────────────┴──────────┘
```

---

*AgentForge Architecture v1.0.0 · Bavaan Engineering*
