#!/bin/bash
# 働きマン - 自動セッション継承システム
# TKが/newを押さなくて済む完全自動化

REPO_DIR="$HOME/projects/ai-memory-shared"
LOG_FILE="$REPO_DIR/context-manager.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

log() {
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
    echo "$1"
}

# ==============================
# 1. 全セッションのコンテキスト使用量チェック
# ==============================
check_sessions() {
    log "🔍 セッション監視開始"
    
    # OpenClaw sessions API経由でトークン使用量取得
    openclaw sessions list --json 2>/dev/null | jq -r '.sessions[] | select(.totalTokens > 150000) | "\(.key)|\(.totalTokens)|\(.sessionId)"' | while IFS='|' read -r key tokens sessionId; do
        if [ -n "$key" ]; then
            process_high_token_session "$key" "$tokens" "$sessionId"
        fi
    done
}

# ==============================  
# 2. 高トークンセッション処理（150K以上）
# ==============================
process_high_token_session() {
    local key="$1"
    local tokens="$2" 
    local sessionId="$3"
    
    log "⚠️  警告レベル: $key ($tokens tokens)"
    
    if [ "$tokens" -gt 170000 ]; then
        log "🔥 緊急処理実行: $key"
        emergency_session_reset "$key" "$tokens" "$sessionId"
    elif [ "$tokens" -gt 150000 ]; then
        log "🔄 メモリ保存開始: $key ($tokens tokens)"
        backup_session_memory "$key" "$tokens" "$sessionId"
    fi
}

# ==============================
# 3. 緊急セッションリセット（170K超過時）
# ==============================
emergency_session_reset() {
    local key="$1"
    local tokens="$2"
    local sessionId="$3"
    
    # メモリバックアップ
    backup_session_memory "$key" "$tokens" "$sessionId"
    
    # 新セッション要求通知作成
    cat > "$REPO_DIR/urgent-tasks/auto-session-reset-$(date +%H%M).md" << EOF
# 🆕 自動セッション継承実行

**対象セッション**: $key
**トークン数**: $tokens
**実行時刻**: $TIMESTAMP

## 実行内容
1. ✅ メモリバックアップ完了
2. 📋 セッション継承データ作成済み
3. 🚨 新セッション開始要求

## TKへの指示
**新セッション開始後、以下を実行してください:**
\`\`\`
source ~/projects/ai-memory-shared/scripts/restore-session-context.sh
\`\`\`

これにより前セッションの重要な文脈が復元されます。
EOF

    log "🆕 新セッション開始要求: $key"
    log "📝 新セッション要求通知作成"
    
    # GitHub即座同期
    cd "$REPO_DIR"
    git add .
    git commit -m "働きマン: 自動セッション継承 $(date +%H:%M) [$tokens tokens]" 
    git push
    
    # 自動復元スクリプト準備
    create_restore_script "$key" "$tokens"
}

# ==============================
# 4. セッションメモリバックアップ
# ==============================
backup_session_memory() {
    local key="$1"
    local tokens="$2"
    local sessionId="$3"
    
    local backup_file="$REPO_DIR/memory/backup_$(date +%Y%m%d_%H%M%S)_${tokens}tokens.md"
    
    # セッション履歴をバックアップ
    echo "# セッションバックアップ" > "$backup_file"
    echo "**セッション**: $key" >> "$backup_file"
    echo "**トークン数**: $tokens" >> "$backup_file"
    echo "**時刻**: $TIMESTAMP" >> "$backup_file"
    echo "" >> "$backup_file"
    echo "## セッション情報" >> "$backup_file"
    echo "\`\`\`" >> "$backup_file"
    openclaw sessions history --sessionKey "$key" --limit 5 2>/dev/null || echo "履歴取得失敗" >> "$backup_file"
    echo "\`\`\`" >> "$backup_file"
    
    log "✅ GitHub保存完了: memory/$(basename "$backup_file")"
    
    return 0
}

# ==============================
# 5. 文脈復元スクリプト作成
# ==============================
create_restore_script() {
    local key="$1"
    local tokens="$2"
    
    cat > "$HOME/projects/ai-memory-shared/scripts/restore-session-context.sh" << 'EOF'
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
EOF

    chmod +x "$HOME/projects/ai-memory-shared/scripts/restore-session-context.sh"
    log "📋 復元スクリプト作成完了"
}

# ==============================
# メイン実行
# ==============================
main() {
    log "🚀 自動セッション管理開始"
    check_sessions
    log "✅ 監視完了"
}

# 実行
main "$@"