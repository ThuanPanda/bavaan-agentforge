# Hướng Dẫn Triển Khai — Team Backend
## AgentForge v210.0 · NestJS / Prisma / Multi-Tenant

---

## Backend Agent làm được gì?

| Trước | Sau |
|---|---|
| Đọc ticket → viết service thủ công | Agent fetch ticket + schema → generate draft |
| Thường quên tenantId trong query | CONSTRAINTS enforce → 0 violations |
| Review bị reject vì standard violations | Husky block trước khi commit |
| PR description viết thủ công | Auto-gen với checklist + Monday link |
| Test viết sau (thường skip) | Tests generated cùng service |

---

## Setup (1 tiếng — làm 1 lần)

### Bước 1: Cài Claude Desktop + Upload skills
```
Settings → Capabilities → Skills
Upload: ai-skills/v210.0/backend/bavaan-backend-skills.zip
Toggle ON: bavaan-backend-agent
```

### Bước 2: Cấu hình MCP
```bash
# Copy env
cp .env.example .env.local
# Điền vào: MONDAY_API_TOKEN, GITHUB_PAT, DATABASE_URL
bash scripts/mcp-setup.sh
```

### Bước 3: Setup Husky
```bash
bash scripts/husky-setup.sh
# Test: git commit --allow-empty -m "test hooks"
```

### Bước 4: Verify
```
# Hỏi Claude:
"Use Monday MCP to fetch TICKET-001, use GitHub MCP to fetch
prisma/schema.prisma, then generate a NestJS service for this ticket."
```

---

## Workflow hàng ngày

### Bắt đầu task mới

```
Bạn: "ai-task start TICKET-456"

Claude:
1. Monday MCP → fetch TICKET-456 details + ACs
2. GitHub MCP → fetch prisma/schema.prisma
3. Backend Agent → generate:
   - src/user-profile/user-profile.module.ts
   - src/user-profile/user-profile.controller.ts
   - src/user-profile/user-profile.service.ts
   - src/user-profile/dto/create-user-profile.dto.ts
   - src/user-profile/dto/update-user-profile.dto.ts
   - src/user-profile/user-profile.service.spec.ts

Bạn: review logic, adjust business rules nếu cần
```

### Trước khi commit (Husky tự chạy)

```
git add .
git commit -m "feat: add user profile service"

→ Husky chạy tự động:
  ✓ Prettier check
  ✓ NestJS boundary check
  ✓ tenantId enforcement check
  ✓ Jest unit tests
  → PASS: commit proceeds
  → FAIL: output specific issue + fix suggestion
```

### Khi Husky fail

```
Bạn: "Husky failed vì thiếu tenantId trong findMany.
      Đây là error output: [paste error]
      Fix cho tôi."

Claude: Xác định file + line, generate fix diff
```

---

## Quy tắc tenantId (PHẢI tuân thủ)

```typescript
// ✅ ĐÚNG — findMany
async findAll(tenantId: string) {
  return this.prisma.project.findMany({ where: { tenantId } });
}

// ✅ ĐÚNG — create
async create(dto: CreateDto, tenantId: string) {
  return this.prisma.project.create({ data: { ...dto, tenantId } });
}

// ✅ ĐÚNG — findOne
async findOne(id: string, tenantId: string) {
  const item = await this.prisma.project.findUnique({ where: { id } });
  if (!item || item.tenantId !== tenantId) throw new NotFoundException();
  return item;
}

// ❌ SAI — không có tenantId
async findAll() {
  return this.prisma.project.findMany(); // → sẽ bị Husky block
}
```

---

## Prompts chuẩn

```
# Generate service từ ticket
"ai-task start TICKET-[ID]. Fetch ticket từ Monday MCP,
fetch schema từ GitHub MCP path prisma/schema.prisma,
generate NestJS service với tenant isolation."

# Generate migration
"TICKET-[ID] cần thêm field mới vào User model.
Fetch schema hiện tại từ GitHub, generate Prisma migration
file (reversible, up + down)."

# Fix Husky violation
"Husky failed với lỗi: [paste error output].
Fix tenantId enforcement cho tôi."

# Tạo PR description
"Generate PR description cho branch [branch-name].
Link đến TICKET-[ID] trên Monday.
Include standard checklist."
```

---

## Đo lường (sau 4 tuần)

- [ ] Số violations bị reject trong PR review (target: 0)
- [ ] Thời gian từ ticket assign → PR ready (target: giảm 35%)
- [ ] Số lần Husky fail trước khi commit xanh (learning curve)
- [ ] Test coverage trung bình (target: ≥ 80% cho code mới)

---

*Cần hỗ trợ: #backend trên Teams · Xem [multi-tenant-patterns.md](../../ai-skills/v210.0/_shared/references/multi-tenant-patterns.md)*
