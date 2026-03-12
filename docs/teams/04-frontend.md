# Hướng Dẫn Triển Khai — Team Frontend
## AgentForge v210.0 · Next.js 14 / Figma / Tailwind

---

## Frontend Agent làm được gì?

| Trước | Sau |
|---|---|
| Đo màu + spacing từ Figma thủ công | Figma MCP fetch node → exact values |
| 3-4 review cycles vì Figma mismatch | MCP-accurate → 1-2 cycles |
| Quên data-testid → QA chặn | CONSTRAINTS enforce → tự gen |
| Không biết khi nào dùng 'use client' | Skill phân tích và quyết định |
| a11y bị reject trong review | accessibility-checker.md trước PR |

---

## Setup (30 phút — làm 1 lần)

### Bước 1: Claude Desktop + Skills
```
Settings → Skills → Upload
File: ai-skills/v210.0/frontend/bavaan-frontend-skills.zip
Toggle ON: bavaan-frontend-agent
```

### Bước 2: MCP
```bash
# Cần: FIGMA_API_TOKEN từ Figma → Profile → Personal Access Tokens
cp .env.example .env.local
bash scripts/mcp-setup.sh
```

### Bước 3: Husky
```bash
bash scripts/husky-setup.sh
```

---

## Lấy Figma Node ID

```
1. Mở Figma file
2. Click vào component/frame cần build
3. URL sẽ có dạng:
   https://figma.com/file/ABC123/Project?node-id=45:678
4. Node ID = "45:678" (hoặc "45-678" trong API)
5. Paste vào Monday story → Figma link field
```

---

## Workflow hàng ngày

### Build component từ Figma

```
Bạn: "Build component cho TICKET-789.
      Figma node ID: 45:678 trong file ProjectXYZ"

Claude:
1. Figma MCP → getNode("45:678")
   → fetch: colors, spacing, typography, variants, states
2. Map Figma tokens → Tailwind classes
3. Generate:
   - components/UserCard/UserCard.tsx
   - components/UserCard/UserCard.test.tsx
   - components/UserCard/index.ts
4. Add data-testid to all interactive elements
5. Check: use client needed? (yes nếu có onClick/useState)
6. WCAG AA check

Bạn: review visual accuracy, adjust business logic
```

### Khi Figma có animation/motion

```
Bạn: "Component này có hover animation trong Figma.
      Làm thế nào implement?"

Claude: Suggest Framer Motion approach, generate code,
        add note trong PR: "Animation deferred to
        framer-motion — see PR comment for rationale"
```

---

## Quy tắc bắt buộc

```tsx
// ✅ ĐÚNG — data-testid trên mọi interactive element
<button data-testid="submit-btn" aria-label="Submit form">
  Submit
</button>

// ✅ ĐÚNG — use client chỉ khi cần
'use client'  // chỉ thêm nếu có useState/useEffect/events

// ✅ ĐÚNG — explicit TypeScript props
interface UserCardProps {
  name: string
  role: string
  onEdit: () => void  // không dùng any
}

// ❌ SAI — hardcode từ Figma
background: '#F59E0B'  // → dùng var(--color-primary) hoặc Tailwind

// ❌ SAI — thiếu aria
<button onClick={handleDelete}>❌</button>  // → thêm aria-label
```

---

## Prompts chuẩn

```
# Build component
"Build component cho TICKET-[ID].
Figma node ID: [node-id], file: [file-name].
Fetch via Figma MCP và scaffold Next.js component."

# Sync design tokens
"Design system update lên Figma.
Fetch tất cả color/spacing tokens từ Figma MCP
(file: [file-name], page: Design Tokens),
update styles/tokens.css và tailwind.config.ts."

# Accessibility check
"Chạy accessibility check cho component [Name].
Check WCAG AA: contrast, aria, keyboard nav."

# use client decision
"Component [Name] có [list features].
Cần 'use client' directive không? Phân tích."
```

---

## Đo lường (sau 4 tuần)

- [ ] Số PR rejected vì Figma mismatch (target: 0 với Figma MCP)
- [ ] Số review cycles trung bình per component (target: ≤ 2)
- [ ] Số component thiếu data-testid (target: 0)
- [ ] Số accessibility violations trong review (target: 0)

---

*Cần hỗ trợ: #frontend trên Teams*
