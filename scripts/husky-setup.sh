#!/bin/bash
# Husky Pre-commit Hook Setup
# Run: bash scripts/husky-setup.sh

set -e

echo "═══════════════════════════════════════════"
echo "  AgentForge — Husky Pre-commit Setup"
echo "═══════════════════════════════════════════"

# Install Husky
npm install --save-dev husky
npx husky init

# Create pre-commit hook
cat > .husky/pre-commit << 'EOF'
#!/bin/sh
echo "🐶 Husky: Running pre-commit checks..."

# 1. Prettier check
echo "→ Checking code formatting..."
npx prettier --check "src/**/*.ts" "tests/**/*.ts" || {
    echo "❌ Prettier: format errors found. Run: npx prettier --write src/"
    exit 1
}
echo "✅ Prettier: OK"

# 2. NestJS boundary check
echo "→ Checking NestJS module boundaries..."
bash scripts/check-boundaries.sh || {
    echo "❌ Module boundary violation detected"
    exit 1
}
echo "✅ NestJS boundaries: OK"

# 3. Tenant isolation check (staged files only)
echo "→ Checking tenantId enforcement in staged files..."
STAGED_BACKEND=$(git diff --cached --name-only | grep "src/.*\.ts$" | grep -v "spec\|dto\|module\|controller" || true)
if [ -n "$STAGED_BACKEND" ]; then
    bash scripts/check-tenant-isolation.sh --staged-only || {
        echo "❌ tenantId enforcement missing in Prisma queries"
        exit 1
    }
fi
echo "✅ Tenant isolation: OK"

# 4. Jest unit tests
echo "→ Running Jest unit tests..."
npx jest --passWithNoTests --bail --silent || {
    echo "❌ Jest: tests failed. Fix tests before committing."
    exit 1
}
echo "✅ Jest: OK"

echo ""
echo "✅ All pre-commit checks passed. Committing..."
EOF

chmod +x .husky/pre-commit

# Add prepare script to package.json
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.scripts = pkg.scripts || {};
pkg.scripts.prepare = 'husky';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
console.log('✅ Added prepare script to package.json');
"

echo ""
echo "═══════════════════════════════════════════"
echo "  ✅ Husky Setup Complete"
echo ""
echo "  Pre-commit hooks installed:"
echo "  • Prettier format check"
echo "  • NestJS module boundary check"
echo "  • tenantId enforcement check"
echo "  • Jest unit tests"
echo ""
echo "  Test it: git commit -m 'test'"
echo "═══════════════════════════════════════════"
