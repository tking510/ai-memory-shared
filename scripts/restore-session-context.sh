#!/bin/bash
echo "🔄 セッション文脈復元中..."
echo "前セッションの重要なコンテキストを読み込みます。"

# AI Memory Shared最新同期
cd ~/projects/ai-memory-shared
git pull

# 最新のバックアップファイル確認
LATEST_BACKUP=$(ls -t memory/backup_*.md | head -1)
if [ -f "$LATEST_BACKUP" ]; then
    echo "✅ 前セッション文脈: $LATEST_BACKUP"
    echo "📋 継続可能な状態で新セッション開始済み"
else
    echo "❌ バックアップファイルが見つかりません"
fi

echo "🎯 システム準備完了！通常の作業を継続してください。"
