# Monday.com MCP Configuration
## bavaan-agentforge · mcp-config/monday.md

---

## Setup

### 1. Get API credentials

1. Log in to Monday.com as Admin
2. Go to: Profile → Developers → My Access Tokens
3. Create token with scopes: `boards:read`, `boards:write`, `items:read`, `items:write`
4. Save token as GitHub Secret: `MONDAY_API_TOKEN`

### 2. Add to MCP config

```json
{
  "mcpServers": {
    "monday": {
      "command": "npx",
      "args": ["-y", "@mondaycom/monday-mcp-server"],
      "env": {
        "MONDAY_API_KEY": "${MONDAY_API_TOKEN}"
      }
    }
  }
}
```

Place in: `~/.config/claude/mcp.json` (Claude Desktop) or project `.mcp.json`

---

## Usage patterns in skills

### Fetch specific Epic by ID
```graphql
query GetEpic($id: ID!) {
  items(ids: [$id]) {
    id
    name
    column_values {
      id
      text
      value
    }
    subitems {
      id
      name
      column_values { id text }
    }
  }
}
```

### Update story status
```graphql
mutation UpdateStatus($itemId: ID!, $boardId: ID!, $columnId: String!, $value: JSON!) {
  change_column_value(
    item_id: $itemId
    board_id: $boardId
    column_id: $columnId
    value: $value
  ) {
    id
  }
}
```

### Create bug item
```graphql
mutation CreateBugItem($boardId: ID!, $groupId: String!, $name: String!, $columnValues: JSON!) {
  create_item(
    board_id: $boardId
    group_id: $groupId
    item_name: $name
    column_values: $columnValues
  ) {
    id
  }
}
```

---

## Board structure (Bavaan standard)

```
Boards:
├── Sprint Board
│   ├── Epics
│   ├── Stories (linked to Epics)
│   └── Bugs
├── Backlog
└── Releases
```

## Column IDs (update for your workspace)
```
status_column_id: "status"
assignee_column_id: "person"
sprint_column_id: "sprint"
story_points_column_id: "numbers"
ticket_type_column_id: "dropdown"  (Epic/Story/Bug/Tech Debt)
```

---

*Update column IDs from: Monday Admin → Board → Column settings → Copy column ID*
