#!/bin/bash
# インテリ君 - GitHub Memory Manager
# 170K超過時の自動記憶保存 & Compaction対応

REPO_DIR="$HOME/.openclaw/workspace/ai-memory-shared"
WORKSPACE="$HOME/.openclaw/workspace"
TIMESTAMP=$(date '+%Y-%m-%d_%H%M')
DATE=$(date '+%Y-%m-%d')

cd "$REPO_DIR" || exit 1

echo "$(date '+%Y-%m-%d %H:%M:%S') - インテリ君 メモリ管理開始"

# 最新取得
git pull --rebase 2>/dev/null

# ==============================
# 1. ローカル記憶 → GitHub保存
# ==============================

# MEMORY.mdのスナップショット保存
if [ -f "$WORKSPACE/MEMORY.md" ]; then
  cp "$WORKSPACE/MEMORY.md" "$REPO_DIR/shared-memory/intellikun-memory-snapshot.md"
fi

# 今日のdailyメモ保存
if [ -f "$WORKSPACE/memory/$DATE.md" ]; then
  cp "$WORKSPACE/memory/$DATE.md" "$REPO_DIR/shared-memory/intellikun-daily-$DATE.md"
fi

# ==============================
# 2. ステータス更新
# ==============================
cat > "$REPO_DIR/shared-memory/intellikun-status.md" << EOF
# インテリ君ステータス - $(date '+%Y-%m-%d %H:%M:%S')

## 基本情報
- **エージェント**: インテリ君 (@horiekunbot)
- **マシン**: kurodatakashiのMacBook Air
- **モデル**: claude-opus-4-6
- **最終同期**: $(date '+%Y-%m-%d %H:%M:%S')

## 担当領域
- SEO運用 (casino-ranking-jp.com)
- サイト管理 (cajikomi.com)
- 開発補助 (sloten.io)
- データ分析・レポート

## 稼働状態
- **ステータス**: アクティブ
- **HEARTBEAT**: 有効（メモリ同期含む）

---
自動生成: intellikun-memory-manager.sh
EOF

# ==============================
# 3. コミット & プッシュ
# ==============================
git add .
if git diff --cached --quiet; then
  echo "変更なし - スキップ"
else
  git commit -m "intellikun: memory sync $TIMESTAMP"
  git push
  echo "$(date '+%Y-%m-%d %H:%M:%S') - プッシュ完了"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - インテリ君 メモリ管理完了"
