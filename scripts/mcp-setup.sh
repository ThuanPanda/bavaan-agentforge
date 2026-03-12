#!/bin/bash
# AgentForge Setup Script
# Run: bash scripts/mcp-setup.sh

set -e

echo "═══════════════════════════════════════════"
echo "  AgentForge — MCP Setup"
echo "  bavaan-agentforge v1.0.0"
echo "═══════════════════════════════════════════"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Install Node.js 20+ from https://nodejs.org"
    exit 1
fi
echo "✅ Node.js: $(node -v)"

# Check .env.local
if [ ! -f ".env.local" ]; then
    cp .env.example .env.local
    echo "📋 Created .env.local from .env.example"
    echo "⚠️  Please fill in your API keys in .env.local before continuing"
    echo "   Required: MONDAY_API_TOKEN, GITHUB_PAT, FIGMA_API_TOKEN"
    exit 1
fi
echo "✅ .env.local found"

# Install MCP servers
echo ""
echo "📦 Installing MCP servers..."
npm install --save-dev \
    @mondaycom/monday-mcp-server \
    @modelcontextprotocol/server-github \
    @figma/mcp-server-figma \
    @microsoft/mcp-server-graph

echo "✅ MCP servers installed"

# Copy MCP config
MCP_CONFIG="$HOME/.config/claude/mcp.json"
mkdir -p "$HOME/.config/claude"

if [ -f "$MCP_CONFIG" ]; then
    cp "$MCP_CONFIG" "${MCP_CONFIG}.backup"
    echo "📋 Backed up existing MCP config to ${MCP_CONFIG}.backup"
fi

cp mcp-config/mcp.json "$MCP_CONFIG"
echo "✅ MCP config installed to $MCP_CONFIG"

echo ""
echo "═══════════════════════════════════════════"
echo "  ✅ MCP Setup Complete"
echo ""
echo "  Next steps:"
echo "  1. Restart Claude Desktop"
echo "  2. Verify: Ask Claude 'Use Monday MCP to list my tasks'"
echo "  3. Run: bash scripts/husky-setup.sh"
echo "═══════════════════════════════════════════"
