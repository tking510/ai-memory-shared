#!/bin/bash
# AI Memory Repository Sync Script (統一版)

MEMORY_DIR="/Users/ponp/.openclaw/workspace/ai-memory-shared"
AGENT_NAME="${1:-$(whoami)}"

cd "$MEMORY_DIR"

# Pull latest changes
echo "🔄 $(date '+%Y-%m-%d %H:%M:%S'): Memory sync for $AGENT_NAME..."
git pull origin main

# Log the sync  
echo "$(date '+%Y-%m-%d %H:%M:%S GMT+8'): $AGENT_NAME - Memory sync" >> sync-log.md

# Add and commit any changes
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "[$AGENT_NAME] Memory update - $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "✅ Memory updated and pushed"
else
    echo "📝 No changes to commit"  
fi

echo "🧠 Memory sync complete for $AGENT_NAME"
echo "📊 Current files:"
ls -la *.md