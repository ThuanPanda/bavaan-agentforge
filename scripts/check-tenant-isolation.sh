#!/bin/bash
# check-tenant-isolation.sh
# Scans staged or all backend files for missing tenantId in Prisma queries

ERRORS=0
FILES_CHECKED=0

if [ "$1" == "--staged-only" ]; then
    FILES=$(git diff --cached --name-only | grep "src/.*\.service\.ts$" || true)
else
    FILES=$(find src -name "*.service.ts" 2>/dev/null || true)
fi

if [ -z "$FILES" ]; then
    exit 0
fi

echo "Checking tenant isolation in service files..."

for file in $FILES; do
    if [ ! -f "$file" ]; then continue; fi
    FILES_CHECKED=$((FILES_CHECKED + 1))

    # Check for Prisma queries without tenantId
    # Look for findMany/findFirst/create without tenantId in vicinity
    if grep -n "prisma\.\w*\.findMany\|prisma\.\w*\.findFirst" "$file" | grep -v "tenantId" | grep -v "\/\/" > /tmp/violations 2>/dev/null; then
        if [ -s /tmp/violations ]; then
            echo "❌ $file — Prisma query missing tenantId:"
            cat /tmp/violations | sed 's/^/   /'
            ERRORS=$((ERRORS + 1))
        fi
    fi

    if grep -n "prisma\.\w*\.create(" "$file" | grep -v "tenantId" | grep -v "\/\/" > /tmp/violations 2>/dev/null; then
        if [ -s /tmp/violations ]; then
            echo "❌ $file — create() missing tenantId injection:"
            cat /tmp/violations | sed 's/^/   /'
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

echo "Checked: $FILES_CHECKED service files"

if [ $ERRORS -gt 0 ]; then
    echo "❌ $ERRORS tenant isolation violation(s) found"
    echo "   Fix: add 'where: { tenantId }' to all Prisma queries"
    exit 1
else
    echo "✅ Tenant isolation check passed"
    exit 0
fi
