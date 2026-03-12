# AgentForge — Triển Khai Toàn Công Ty
## Hướng dẫn tổng quan · Tất cả teams

---

## Nguyên tắc chuyển đổi

AgentForge không thay thế con người — nó **loại bỏ công việc lặp lại** để mỗi thành viên tập trung vào giá trị cao hơn.

```
TRƯỚC AgentForge:
  PM      → 8h/tuần viết stories từ email
  Dev     → 30% thời gian fix review violations
  QA      → 2h/story viết test cases thủ công
  DevOps  → setup pipeline thủ công từng project

SAU AgentForge:
  PM      → 3h/tuần (AI draft, PM review + approve)
  Dev     → 0 violations (Husky enforce pre-commit)
  QA      → 80% test cases tự động từ ACs
  DevOps  → pipeline và runbook tự động hóa
```

---

## Lộ trình triển khai 8 tuần

```
Tuần 1-2: FOUNDATION
  ✓ Setup Claude với bavaan-ai-skills (IT + Tech Lead)
  ✓ Cấu hình MCP servers (6 servers)
  ✓ Setup Husky pre-commit hooks (tất cả devs)
  ✓ Training CRITICS framework cho toàn team
  ✓ Pilot: 1 story/agent với Orchestrator

Tuần 3-4: PM + ARCHITECT
  ✓ PM Agent: viết Epic đầu tiên từ email
  ✓ PM Agent: Sprint planning với capacity
  ✓ Architect Agent: design schema cho feature mới
  ✓ Architect Agent: ADR đầu tiên
  ✓ Measure: thời gian story writing trước/sau

Tuần 5-6: DEV TEAM
  ✓ Backend Agent: generate service từ ticket
  ✓ Frontend Agent: scaffold component từ Figma
  ✓ DevOps Agent: setup CI/CD qa-gate.yml
  ✓ Husky hooks active cho tất cả devs
  ✓ Measure: PR review cycles, violations

Tuần 7-8: QA + FULL LOOP
  ✓ QA Agent: auto-generate test cases từ ACs
  ✓ QA Agent: Playwright E2E trên mọi PR
  ✓ Full pipeline: email → Epic → Story → Code → PR → Playwright → Merge
  ✓ KPI review: đo lường và điều chỉnh skill files
  ✓ Version bump: v2.1.0 → v2.2.0
```

---

## Trách nhiệm từng role trong setup

| Role | Tuần 1-2 | Tuần 3-4 | Tuần 5-6 | Tuần 7-8 |
|---|---|---|---|---|
| **Tech Lead** | Setup repo, Claude skills | Review Architect output | Review Backend patterns | Sprint KPI review |
| **PM** | Install Claude, MCP | Dùng PM Agent daily | — | Measure time savings |
| **Architect** | Setup MCP | Dùng Architect Agent | Review BE PRs | Tune arch skill files |
| **Backend Dev** | Install Husky | — | Dùng Backend Agent daily | Measure violations |
| **Frontend Dev** | Install Husky | — | Dùng Frontend Agent daily | Measure review cycles |
| **DevOps** | Setup CI/CD | — | Deploy qa-gate.yml | Monitor Playwright |
| **QA/SDET** | — | — | Verify Playwright setup | Dùng QA Agent daily |

---

## Quy tắc vàng

1. **Không bao giờ dump toàn bộ context** → dùng MCP với ID cụ thể
2. **Skill file = code** → mọi thay đổi qua PR, có review
3. **Husky là bắt buộc** → không commit nếu hooks fail
4. **Playwright là merge gate** → không merge nếu test fail
5. **Iterate sau mỗi sprint** → review skill files, version bump nếu cải thiện

---

## Team guides

- [docs/teams/01-pm.md](./01-pm.md) — PM team
- [docs/teams/02-architect.md](./02-architect.md) — Architect team
- [docs/teams/03-backend.md](./03-backend.md) — Backend team
- [docs/teams/04-frontend.md](./04-frontend.md) — Frontend team
- [docs/teams/05-devops.md](./05-devops.md) — DevOps team
- [docs/teams/06-qa.md](./06-qa.md) — QA/SDET team
- [docs/teams/07-rollout-plan.md](./07-rollout-plan.md) — Rollout chi tiết
