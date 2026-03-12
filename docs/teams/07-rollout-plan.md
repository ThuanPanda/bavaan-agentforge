# Kế Hoạch Rollout 8 Tuần
## AgentForge — Triển khai toàn công ty Bavaan

---

## Tổng quan timeline

```
Tuần 1 ─── Tuần 2 ─── Tuần 3 ─── Tuần 4 ─── Tuần 5 ─── Tuần 6 ─── Tuần 7 ─── Tuần 8
[FOUNDATION]           [STRATEGY TEAM]        [DEV TEAM]             [QA + FULL LOOP]
Setup + Training       PM + Architect live     Backend + Frontend     Full pipeline live
                                               DevOps CI/CD           KPI measurement
```

---

## Tuần 1–2: FOUNDATION

### Mục tiêu
- Toàn team có Claude Desktop + Skills configured
- MCP servers kết nối thành công
- Husky hooks active trên tất cả dev machines
- Mọi người hiểu CRITICS framework

### Checklist Tech Lead / DevOps
```
[ ] Tạo repo: bavaan-agentforge (fork từ template này)
[ ] Upload ai-skills lên Claude Workspace (Organization-level nếu có)
[ ] Deploy qa-gate.yml vào main project repos
[ ] Cấu hình GitHub Secrets (6 secrets)
[ ] Enable branch protection: require playwright check
[ ] Tạo .env.example với all required vars
[ ] Test: trigger PR → Playwright runs
```

### Checklist Mỗi Developer
```
[ ] Install Claude Desktop
[ ] Upload bavaan-ai-skills.zip vào Settings → Skills
[ ] Chạy: bash scripts/mcp-setup.sh
[ ] Chạy: bash scripts/husky-setup.sh
[ ] Verify: git commit --allow-empty -m "test" → Husky chạy
[ ] Verify: Hỏi Claude "ai-task start TICKET-001"
```

### Training Session (2h)
```
Agenda:
  30 phút: AgentForge overview + why (context fragmentation problem)
  30 phút: CRITICS framework hands-on (build 1 skill cùng nhau)
  30 phút: Live demo: email → Epic → Story (PM Agent)
  30 phút: Q&A + individual setup support
```

### Success criteria tuần 2
- 100% developers có Husky active
- 100% có Claude với bavaan-ai-skills
- 1 test PR đi qua qa-gate.yml thành công

---

## Tuần 3–4: STRATEGY TEAM (PM + Architect)

### PM Team — Tuần 3
```
Ngày 1-2: PM thử tạo Epic đầu tiên từ email thật
  → Prompt: "Fetch email [subject] từ Graph MCP, tạo Epic"
  → Review output với Tech Lead + PO
  → Ghi nhận: thời gian, chất lượng, điều chỉnh cần thiết

Ngày 3-4: PM chạy Sprint Planning với PM Agent
  → Fetch backlog + capacity
  → So sánh output với sprint planning thông thường

Ngày 5: Retrospective
  → Ghi: thời gian trước/sau
  → Liệt kê edge cases skill cần handle tốt hơn
  → Update pm/SKILL.md nếu cần
```

### Architect Team — Tuần 4
```
Ngày 1-2: Architect thiết kế schema cho feature đang có trong backlog
  → Dùng Architect Agent + multi-tenant-schema-design.md
  → So sánh với cách thông thường

Ngày 3-4: Review PR đầu tiên với pr-arch-reviewer.md
  → Chọn 2-3 PR open hiện tại
  → Chạy Architect Agent review
  → So sánh với manual review

Ngày 5: Update architect/SKILL.md với learnings
```

### Deliverables tuần 3-4
- 2+ Epics tạo bằng PM Agent (live, không test)
- 1 schema design document tạo bằng Architect Agent
- 1 ADR đầu tiên qua Architect Agent
- First iteration của skill refinement notes

---

## Tuần 5–6: DEV TEAM

### Backend Team — Tuần 5
```
Mỗi developer: thực hiện 1 story thật với Backend Agent

Workflow chuẩn:
  1. "ai-task start TICKET-[real ticket]"
  2. Review generated code
  3. Adjust business logic nếu cần
  4. Commit (Husky sẽ catch violations)
  5. PR → qa-gate.yml tự chạy

Ghi nhận:
  - Thời gian từ start → PR ready
  - Số lần Husky block
  - Chất lượng generated code (1-5)
```

### Frontend Team — Tuần 5
```
Mỗi developer: thực hiện 1 component thật với Frontend Agent

Workflow chuẩn:
  1. Lấy Figma node ID từ story
  2. "Build component TICKET-[ID], Figma node: [ID]"
  3. Review component vs Figma design
  4. Commit (Husky check)
  5. PR → qa-gate

Ghi nhận:
  - Số pixel-perfect issues sau review
  - Thời gian từ start → component ready
```

### DevOps — Tuần 6
```
[ ] Deploy qa-gate.yml vào TẤT CẢ active repos
[ ] Verify: Playwright chạy trên mọi PR mở
[ ] Setup monitoring: Datadog/CloudWatch alerts
[ ] Deploy runbook cho next release
[ ] Husky hooks verified trên tất cả dev machines
```

### Deliverables tuần 5-6
- 100% devs đã dùng agents ít nhất 1 story thật
- qa-gate.yml active trên tất cả repos
- First metrics: thời gian, violations, review cycles

---

## Tuần 7–8: QA + FULL PIPELINE

### QA Team — Tuần 7
```
Mỗi story trong sprint:
  1. Status → "Ready for QA" → QA Agent trigger
  2. Fetch ACs từ Monday, generate test cases (5 phút vs 2h)
  3. Generate Playwright spec (POM + factories)
  4. Review spec
  5. Spec auto-runs trên mọi PR qua DevOps qa-gate

Ngày 3-4: Full regression run với QA Agent
Ngày 5: AC coverage validation toàn sprint
```

### Full Loop Verification — Tuần 8
```
Target: 1 complete feature end-to-end qua AgentForge

Email/Teams → PM Agent → Epic + Stories on Monday
→ Architect Agent → Tech spec + Schema + API contract
→ Backend Agent → Services + DTOs (Husky enforced)
→ Frontend Agent → Components từ Figma MCP
→ DevOps → qa-gate.yml: Playwright E2E
→ QA Agent → AC validation + bug reports
→ Architect review → Merge
→ PM Agent → Release notes

Đo thời gian toàn vòng → so sánh với pre-AgentForge baseline
```

### KPI Review — Tuần 8 (buổi họp)
```
Agenda:
  15 phút: Trình bày metrics vs targets
  20 phút: Skill files nào cần cải thiện?
  15 phút: Version bump ceremony: v1.0.0 → v2.2.0
  10 phút: Roadmap: v2.2.0 improvements
```

---

## KPI Dashboard (cập nhật hàng tuần)

| Metric | Baseline | Tuần 4 | Tuần 6 | Tuần 8 | Target |
|---|---|---|---|---|---|
| Story writing time (h/week) | 8h | ? | ? | ? | 3h |
| PR violations caught in review | N | ? | ? | ? | 0 |
| Test cases manual vs auto (%) | 100% manual | ? | ? | ? | 20% manual |
| Playwright gate active repos | 0% | ? | ? | ? | 100% |
| Sprint velocity change | baseline | ? | ? | ? | +40% |
| Bug escape rate | baseline | ? | ? | ? | -70% |

---

## Troubleshooting thường gặp

| Vấn đề | Nguyên nhân | Fix |
|---|---|---|
| Claude không trigger skill | Description không đủ trigger phrases | Thêm phrases vào SKILL.md description |
| Playwright flaky trên CI | Next.js hydration timing | Add `expect.poll()` + increase timeout |
| Husky quá chậm | Jest chạy toàn bộ test suite | Config Jest để chỉ chạy affected tests |
| MCP timeout | Token expired | Refresh trong Settings → Extensions |
| tenantId violation bị miss | Service file không trong src/ | Update check-tenant-isolation.sh paths |

---

## Iteration cycle (sau tuần 8, mỗi sprint)

```
Trong sprint:
  → Ghi nhận edge cases skill chưa handle tốt
  → Ghi nhận prompts nào work tốt (dùng lại)

Cuối sprint:
  → Review SKILL.md files cần update
  → PR vào bavaan-agentforge với changes
  → Sau approve → version bump (v2.1.x → v2.1.x+1)
  → Upload skills mới lên Claude.ai Workspace
```

---

*AgentForge Rollout Plan v1.0.0 · Bavaan Engineering*
