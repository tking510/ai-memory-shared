#!/bin/bash
# インテリ君 - コンテキストサイズ監視 & 自動アーカイブ
# heartbeat連携で実行される

WORKSPACE="$HOME/.openclaw/workspace"
REPO_DIR="$WORKSPACE/ai-memory-shared"
ARCHIVE_DIR="$REPO_DIR/memory"
LOG_FILE="$REPO_DIR/logs/context-monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$ARCHIVE_DIR" "$REPO_DIR/logs"

log() {
  echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
  echo "$1"
}

# ==============================
# 1. ワークスペースmdファイルの合計サイズ取得
# ==============================
TOTAL_KB=$(find "$WORKSPACE" -maxdepth 1 -name "*.md" -exec cat {} + 2>/dev/null | wc -c | awk '{printf "%.0f", $1/1024}')
MEMORY_KB=$(find "$WORKSPACE/memory" -name "*.md" -exec cat {} + 2>/dev/null | wc -c | awk '{printf "%.0f", $1/1024}')
ALL_KB=$((TOTAL_KB + MEMORY_KB))

log "ワークスペースサイズ: root=${TOTAL_KB}KB memory=${MEMORY_KB}KB total=${ALL_KB}KB"

# ==============================
# 2. 段階的対策
# ==============================
if [ "$ALL_KB" -ge 170 ]; then
  log "🔴 CRITICAL (170KB+): 全記憶をGitHubにダンプ"
  
  # MEMORY.mdバックアップ
  cp "$WORKSPACE/MEMORY.md" "$ARCHIVE_DIR/intellikun-memory-emergency-$(date +%Y%m%d_%H%M).md" 2>/dev/null
  
  # 古いdailyファイルをアーカイブ（3日以上前）
  find "$WORKSPACE/memory" -name "202*.md" -mtime +3 -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null
  
  log "緊急アーカイブ完了"

elif [ "$ALL_KB" -ge 120 ]; then
  log "🟡 WARNING (120KB+): 予防的アーカイブ実行"
  
  # 7日以上前のdailyファイルをアーカイブ
  find "$WORKSPACE/memory" -name "202*.md" -mtime +7 -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null
  
  log "予防アーカイブ完了"

else
  log "🟢 OK: サイズ正常"
fi

# ==============================
# 3. 監視ログをGitHubに保存
# ==============================
cat > "$REPO_DIR/shared-memory/intellikun-context-status.md" << EOF
# インテリ君 コンテキスト監視レポート
最終チェック: $TIMESTAMP

## サイズ状況
| 項目 | サイズ |
|------|--------|
| ルートmd | ${TOTAL_KB}KB |
| memoryフォルダ | ${MEMORY_KB}KB |
| 合計 | ${ALL_KB}KB |

## ステータス
$(if [ "$ALL_KB" -ge 170 ]; then echo "🔴 CRITICAL - 緊急アーカイブ実行済み"; elif [ "$ALL_KB" -ge 120 ]; then echo "🟡 WARNING - 予防アーカイブ実行済み"; else echo "🟢 OK - 正常範囲"; fi)

## 閾値
- 🟢 OK: 0-119KB
- 🟡 WARNING: 120-169KB → 古いファイル自動アーカイブ
- 🔴 CRITICAL: 170KB+ → 緊急ダンプ＆全アーカイブ
EOF

# ==============================
# 4. GitHubに同期
# ==============================
cd "$REPO_DIR"
git pull --rebase 2>/dev/null
git add .
if ! git diff --cached --quiet; then
  git commit -m "intellikun: context monitor $(date '+%H:%M') [${ALL_KB}KB]"
  git push 2>/dev/null
  log "GitHub同期完了"
fi

log "監視完了"
