# Hướng Dẫn Triển Khai — Team DevOps
## AgentForge v210.0 · GitHub Actions / Playwright Gate / IaC

---

## DevOps Agent làm được gì?

| Trước | Sau |
|---|---|
| Setup CI/CD pipeline từ đầu mỗi project | Agent generate qa-gate.yml chuẩn |
| Playwright chỉ chạy khi nhớ | Tự động trigger mọi PR, block merge |
| Deploy checklist viết thủ công | Auto-gen runbook từ service config |
| IaC viết từ scratch | Terraform + Helm templates từ spec |
| Không có multi-tenant test isolation | Fresh seed 2 tenants mỗi run |

---

## Setup (2 tiếng — làm 1 lần cho cả team)

### Bước 1: Deploy qa-gate.yml

```bash
# Copy workflow vào repo
mkdir -p .github/workflows
cp ci-cd/github-actions/qa-gate.yml .github/workflows/

# Push lên GitHub
git add .github/workflows/qa-gate.yml
git commit -m "ci: add AgentForge QA gate workflow"
git push
```

### Bước 2: Cấu hình GitHub Secrets

```
GitHub repo → Settings → Secrets → Actions → New secret

MONDAY_API_TOKEN       = [từ Monday admin]
TEST_DATABASE_URL      = postgresql://...@.../bavaan_test
STAGING_API_URL        = https://staging-api.bavaan.com
CLERK_SECRET_KEY       = [Clerk testing key]
```

### Bước 3: Branch protection rules

```
GitHub → Settings → Branches → Add rule

Branch: main
✅ Require status checks: qa-gate/playwright
✅ Require branches to be up to date
✅ Require linear history
❌ Allow force pushes (KHÔNG cho phép)
```

### Bước 4: Seed script

```bash
# Tạo test seed script
cat > scripts/seed-test.ts << 'EOF'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  // Tenant 1
  await prisma.tenant.upsert({
    where: { id: 'tenant-test-001' },
    create: { id: 'tenant-test-001', name: 'Test Tenant Alpha' },
    update: {}
  })
  // Tenant 2
  await prisma.tenant.upsert({
    where: { id: 'tenant-test-002' },
    create: { id: 'tenant-test-002', name: 'Test Tenant Beta' },
    update: {}
  })
  // Seed users, projects, etc. per tenant
  console.log('✅ Test seed complete: 2 tenants')
}

main().catch(console.error).finally(() => prisma.$disconnect())
EOF
```

---

## Monitoring Playwright results

### Khi test fail

```
GitHub Actions → Actions tab → failed run
→ Download playwright-report artifact
→ Mở index.html → xem screenshots + error

Hoặc hỏi Claude:
"Playwright failed với error: [paste]. Root cause là gì?
Test file: [paste spec file]. Fix suggestion?"
```

### Xử lý flaky tests

```
Bạn: "Test 'AC-3: Password reset' flaky trên CI.
      Pass locally nhưng fail CI khoảng 20%.
      Spec file: [paste]. Fix?"

Claude: Analyze → thường là:
  - Next.js hydration timing → add expect.poll()
  - Async state update → increase timeout
  - Port conflict → dynamic port
  → Generate fix diff
```

---

## Prompts chuẩn

```
# Setup CI/CD cho service mới
"Setup GitHub Actions QA gate cho service [name].
Stack: NestJS + Next.js. Multi-tenant DB.
Generate: qa-gate.yml + branch protection config."

# Deploy runbook
"Generate deployment runbook cho release [version].
Fetch service config từ GitHub MCP.
Include pre/post deployment checklist + rollback steps."

# IaC cho service mới
"Generate Terraform module cho [service-name].
Requirements: RDS PostgreSQL multi-AZ, ECS service,
VPC security group. Multi-tenant namespace."

# Monitoring setup
"Configure Datadog alerts cho [service]:
- Error rate > 1% → P2
- Latency p99 > 2s → P2
- DB connection pool > 80% → P1"
```

---

## Đo lường (sau 4 tuần)

- [ ] Số PR merged mà không qua Playwright (target: 0)
- [ ] Mean time to detect failing test (target: < 10 phút)
- [ ] Deploy frequency (target: +3x so với trước)
- [ ] Mean time to recovery sau incident (target: -60%)
- [ ] Số manual CI/CD setups (target: 0 — tất cả từ template)

---

*Cần hỗ trợ: #devops trên Teams*
