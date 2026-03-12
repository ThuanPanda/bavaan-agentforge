# Hướng Dẫn Triển Khai — Team Architect
## AgentForge v1.0.0 · System Design / Multi-Tenant / API Contracts

---

## Architect Agent làm được gì?

| Trước | Sau |
|---|---|
| Tech spec + ADR mất 1-2 ngày | AI draft trong 2-4h + architect polish |
| Schema design từ blank canvas | Agent fetch existing schema + propose changes |
| PR review thủ công (có thể miss anti-patterns) | pr-arch-reviewer.md check tự động |
| API contract sau khi dev đã code | OpenAPI spec trước khi dev bắt đầu |

---

## Setup (30 phút)

### Bước 1: Claude + Skills
```
Settings → Skills → Upload: bavaan-architect-skills.zip
Toggle ON: bavaan-architect-agent
```

### Bước 2: MCP
```bash
cp .env.example .env.local
# Cần: GITHUB_PAT, SHAREPOINT_SITE_URL, FIGMA_API_TOKEN
bash scripts/mcp-setup.sh
```

---

## Workflow

### Thiết kế tính năng mới

```
Bạn: "Epic E-045: Multi-tenant reporting dashboard.
      Fetch PRD từ SharePoint /docs/epics/E-045-PRD.docx,
      fetch schema từ GitHub, design schema changes + API contracts."

Claude:
1. SharePoint MCP → fetch PRD
2. GitHub MCP → fetch schema.prisma
3. Generate schema: Report, ReportFilter models với tenantId
4. Generate ADR: design decision + alternatives
5. Generate OpenAPI spec: GET /reports, POST /reports/generate
6. Upload ADR → SharePoint /architecture/adrs/

Bạn: review, challenge assumptions, approve + merge PR
```

### PR Architecture Review (auto-triggered sau Playwright)

```
GitHub Actions tự gọi Architect Agent sau Playwright pass.
Kết quả trên PR comment:

🏗️ Architect Review: PASSED
  ✅ tenantId on all Prisma queries
  ✅ No synchronous cross-service calls
  ✅ NestJS module boundaries respected

hoặc:

🏗️ Architect Review: ISSUES FOUND
  ❌ Line 45: UserService.getAll() — missing tenantId filter
  ❌ Line 78: Direct HTTP call to PaymentService (use event instead)
```

---

## Prompts chuẩn

```
# Tech spec + schema
"Epic [ID]: [tên]. Fetch PRD từ SharePoint [path],
fetch current schema từ GitHub, design:
1. Schema changes (with tenantId)
2. ADR for design decisions
3. OpenAPI spec for new endpoints"

# Microservice boundary review
"Review PR #[N]. Check:
- Synchronous blocking calls?
- Shared DB between services?
- tenantId missing in queries?
Post PR comment với findings."

# Migration analysis
"Schema migration cần thêm [fields] vào [model].
Fetch current schema từ GitHub.
Generate: migration file (reversible) + migration risks."
```

---

## Đo lường (sau 4 tuần)

- [ ] Thời gian viết tech spec (target: giảm 60%)
- [ ] Số architectural violations tìm thấy trong PR review (target: giảm 80% so với manual)
- [ ] Số ADRs được viết (target: tăng 2x — vì dễ hơn)
- [ ] Số incidents liên quan đến missing tenantId (target: 0)

---

*Cần hỗ trợ: #architecture trên Teams*
