# MCP Server Configuration Guide
## bavaan-agentforge · All 6 MCP Servers

---

## Master config file: .mcp.json (project root)

```json
{
  "mcpServers": {
    "monday": {
      "command": "npx",
      "args": ["-y", "@mondaycom/monday-mcp-server"],
      "env": { "MONDAY_API_KEY": "${MONDAY_API_TOKEN}" }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}" }
    },
    "figma": {
      "command": "npx",
      "args": ["-y", "@figma/mcp-server-figma"],
      "env": { "FIGMA_API_KEY": "${FIGMA_API_TOKEN}" }
    },
    "microsoft-graph": {
      "command": "npx",
      "args": ["-y", "@microsoft/mcp-server-graph"],
      "env": {
        "TENANT_ID": "${MS_TENANT_ID}",
        "CLIENT_ID": "${MS_CLIENT_ID}",
        "CLIENT_SECRET": "${MS_CLIENT_SECRET}"
      }
    },
    "sharepoint": {
      "command": "npx",
      "args": ["-y", "@bavaan/mcp-server-sharepoint"],
      "env": {
        "SHAREPOINT_SITE_URL": "${SHAREPOINT_SITE_URL}",
        "CLIENT_ID": "${MS_CLIENT_ID}",
        "CLIENT_SECRET": "${MS_CLIENT_SECRET}"
      }
    },
    "prisma": {
      "command": "npx",
      "args": ["-y", "@prisma/mcp-server"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}",
        "SCHEMA_PATH": "./prisma/schema.prisma"
      }
    }
  }
}
```

---

## Required GitHub Secrets (for CI/CD)

```
MONDAY_API_TOKEN       ← Monday.com API token
GITHUB_PAT             ← GitHub Personal Access Token (repo, PR)
FIGMA_API_TOKEN        ← Figma personal access token
MS_TENANT_ID           ← Azure AD tenant ID
MS_CLIENT_ID           ← Azure app registration client ID
MS_CLIENT_SECRET       ← Azure app registration secret
SHAREPOINT_SITE_URL    ← https://bavaan.sharepoint.com/sites/engineering
DATABASE_URL           ← PostgreSQL connection string (test env)
```

---

## Setup checklist per developer

```bash
# 1. Copy env template
cp .env.example .env.local

# 2. Fill in values:
MONDAY_API_TOKEN=...
GITHUB_PAT=...
FIGMA_API_TOKEN=...
# (get remaining from IT/DevOps team)

# 3. Run setup script
bash scripts/mcp-setup.sh

# 4. Test connection
# Ask Claude: "Use Monday MCP to list my active sprint items"
# Ask Claude: "Use GitHub MCP to show my open PRs"
```

---

## Per-server setup guides

| Server | Guide | Who sets up |
|---|---|---|
| Monday.com | [monday.md](./monday.md) | Each developer |
| GitHub | [github.md](./github.md) | Each developer |
| Figma | [figma.md](./figma.md) | FE + Arch team |
| Microsoft Graph | [msgraph.md](./msgraph.md) | IT Admin (once) |
| SharePoint | [sharepoint.md](./sharepoint.md) | IT Admin (once) |
| Prisma/DB | [prisma.md](./prisma.md) | BE team |

---

## Troubleshooting

```
Problem: MCP server not connecting
Fix:     Check env variable is set: echo $MONDAY_API_TOKEN

Problem: Monday items not found
Fix:     Verify board ID is correct in skill file

Problem: Figma node not found
Fix:     Ensure node ID is from the correct Figma file URL

Problem: MS Graph permission denied
Fix:     IT Admin needs to grant consent in Azure AD portal
```
