# 🤖 AgentForge — AI-First Multi-Agent Framework
### bavaan-agentforge · v210.0 · Powered by Claude (Anthropic)

---

## Mục tiêu

AgentForge đưa toàn bộ vòng đời phát triển phần mềm tại Bavaan vào hệ thống
**AI-First** với 7 agents chuyên biệt, kết nối qua **MCP** (Model Context Protocol),
mỗi agent có bộ **CRITICS Skill Executables** riêng, versioned như code.

## Kết quả kỳ vọng

| Metric | Target |
|---|---|
| Giảm thời gian task lặp lại | **40%** |
| Tăng throughput mỗi thành viên | **2–3×** |
| Code standard violations | **~0** (Husky enforcement) |
| Test cases tự động từ ACs | **80%** |
| PR có Playwright gate | **100%** |
| Bug escape rate | **–70%** |
| Token cost reduction | **–65%** vs bulk loading |
| Multi-tenant violations | **0** |

## Cấu trúc nhanh

```
bavaan-agentforge/
├── README.md                    ← File này
├── ARCHITECTURE.md              ← Kiến trúc tổng thể
├── CHANGELOG.md                 ← Version history
│
├── ai-skills/v210.0/            ← Versioned Prompt Registry
│   ├── _orchestrator/           ← Command layer (claude-opus-4)
│   ├── pm/                      ← PM Agent skills
│   ├── architect/               ← Architect Agent skills
│   ├── backend/                 ← Backend Dev skills (NestJS/Prisma)
│   ├── frontend/                ← Frontend Dev skills (Next.js/Figma)
│   ├── devops/                  ← DevOps skills (GitHub Actions)
│   ├── qa/                      ← QA/SDET skills (Playwright)
│   └── _shared/                 ← Shared references & templates
│
├── mcp-config/                  ← MCP server configs (6 servers)
├── ci-cd/                       ← GitHub Actions workflows
├── scripts/                     ← Setup scripts
├── docs/teams/                  ← Hướng dẫn triển khai từng team
└── architecture/                ← Diagrams & decision records
```

## Quick Start

```bash
# 1. Clone
git clone https://github.com/bavaan/bavaan-agentforge.git

# 2. Upload skills lên Claude.ai
#    Settings > Capabilities > Skills > Upload
cd ai-skills/v210.0 && zip -r bavaan-skills.zip .

# 3. Setup MCP
bash scripts/mcp-setup.sh

# 4. Setup Husky pre-commit
bash scripts/husky-setup.sh

# 5. Verify
# Hỏi Claude: "ai-task start TICKET-123"
```

## Đọc thêm

| File | Nội dung |
|---|---|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Kiến trúc tổng thể, sơ đồ, luồng |
| [docs/teams/00-overview.md](./docs/teams/00-overview.md) | Overview triển khai toàn công ty |
| [docs/teams/01-pm.md](./docs/teams/01-pm.md) | Team PM |
| [docs/teams/02-architect.md](./docs/teams/02-architect.md) | Team Architect |
| [docs/teams/03-backend.md](./docs/teams/03-backend.md) | Team Backend |
| [docs/teams/04-frontend.md](./docs/teams/04-frontend.md) | Team Frontend |
| [docs/teams/05-devops.md](./docs/teams/05-devops.md) | Team DevOps |
| [docs/teams/06-qa.md](./docs/teams/06-qa.md) | Team QA/SDET |
| [docs/teams/07-rollout-plan.md](./docs/teams/07-rollout-plan.md) | Kế hoạch rollout 8 tuần |

---
*Bavaan Engineering · v210.0*
