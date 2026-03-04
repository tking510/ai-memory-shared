#!/bin/bash
# 🔥 自動コンテキスト管理スクリプト - やります君作成
# TK指示: 「止まらんように」を実現

# 設定
WORKSPACE_DIR="/Users/ponp/.openclaw/workspace-yarimasu"
MEMORY_DIR="$WORKSPACE_DIR/memory"
ARCHIVE_PREFIX="archive-"
WARNING_120KB=122880  # 120KB
ALERT_150KB=153600    # 150KB  
CRITICAL_170KB=174080 # 170KB

# ログ関数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ファイルサイズチェック
check_total_size() {
    cd "$WORKSPACE_DIR"
    total_size=$(wc -c *.md 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
    echo "$total_size"
}

# 🟡 120KB対策 - 注意レベル
level_120kb_action() {
    log "🟡 120KB注意レベル - 自動整理開始"
    cd "$WORKSPACE_DIR"
    
    # 5KB以上のファイルを自動アーカイブ
    mkdir -p "$MEMORY_DIR"
    
    for file in *.md; do
        if [[ -f "$file" && "$file" != "MEMORY.md" && "$file" != "TOOLS.md" && "$file" != "SOUL.md" ]]; then
            size=$(wc -c < "$file" 2>/dev/null || echo "0")
            if [[ $size -gt 5120 ]]; then  # 5KB
                log "📦 アーカイブ: $file ($size bytes)"
                mv "$file" "$MEMORY_DIR/${ARCHIVE_PREFIX}$file"
            fi
        fi
    done
}

# 🟠 150KB対策 - 警戒レベル  
level_150kb_action() {
    log "🟠 150KB警戒レベル - 積極的圧縮開始"
    cd "$WORKSPACE_DIR"
    
    # 3KB以上もアーカイブ対象に
    for file in *.md; do
        if [[ -f "$file" && "$file" != "MEMORY.md" && "$file" != "TOOLS.md" && "$file" != "SOUL.md" ]]; then
            size=$(wc -c < "$file" 2>/dev/null || echo "0")
            if [[ $size -gt 3072 ]]; then  # 3KB
                log "🗂️ 警戒アーカイブ: $file ($size bytes)"
                mv "$file" "$MEMORY_DIR/${ARCHIVE_PREFIX}$file"
            fi
        fi
    done
    
    # セッション状態保存
    log "💾 セッション状態保存準備"
    echo "$(date): 150KB警戒レベル対策実行" >> "$MEMORY_DIR/context-management.log"
}

# 🔴 170KB対策 - 緊急レベル
level_170kb_action() {
    log "🔴 170KB緊急レベル - セッション継承準備"
    
    # 緊急アーカイブ（必須ファイル以外すべて）
    cd "$WORKSPACE_DIR"
    for file in *.md; do
        if [[ -f "$file" && "$file" != "MEMORY.md" && "$file" != "TOOLS.md" && "$file" != "SOUL.md" && "$file" != "USER.md" && "$file" != "IDENTITY.md" ]]; then
            log "⚡ 緊急アーカイブ: $file"
            mv "$file" "$MEMORY_DIR/${ARCHIVE_PREFIX}$file"
        fi
    done
    
    # セッション継承フラグ
    echo "CRITICAL_CONTEXT_RESET_NEEDED" > "$MEMORY_DIR/session-reset-flag.txt"
    log "🚨 セッション継承フラグ設定完了"
}

# メイン処理
main() {
    log "🔥 自動コンテキスト管理開始"
    
    current_size=$(check_total_size)
    log "📊 現在のサイズ: $current_size bytes"
    
    if [[ $current_size -gt $CRITICAL_170KB ]]; then
        level_170kb_action
    elif [[ $current_size -gt $ALERT_150KB ]]; then
        level_150kb_action  
    elif [[ $current_size -gt $WARNING_120KB ]]; then
        level_120kb_action
    else
        log "✅ サイズOK - 対策不要"
    fi
    
    # 最終サイズ確認
    final_size=$(check_total_size)
    log "📊 処理後サイズ: $final_size bytes"
    log "🔥 自動コンテキスト管理完了"
}

# 実行
main "$@"