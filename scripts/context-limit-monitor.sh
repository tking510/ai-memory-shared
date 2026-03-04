#!/bin/bash
# 🔥 コンテキスト制限監視スクリプト - やります君作成
# TK指示: コンテキスト制限対策監視

# 設定
WORKSPACE_DIR="/Users/ponp/.openclaw/workspace-yarimasu"
ARCHIVE_DIR="../archived-workspace-files"
TARGET_SIZE_KB=70
WARNING_SIZE_KB=60

# ログ関数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 現在のサイズ確認（KB）
check_current_size() {
    cd "$WORKSPACE_DIR"
    size_kb=$(find . -maxdepth 2 -name "*.md" -not -path "./node_modules/*" -not -path "./projects/*" -exec du -c {} + | tail -1 | awk '{print $1}')
    echo "$size_kb"
}

# 保護ファイルチェック
is_protected_file() {
    local file="$1"
    case "$file" in
        "MEMORY.md"|"AGENTS.md"|"TOOLS.md"|"HEARTBEAT.md"|"SOUL.md"|"USER.md"|"IDENTITY.md"|"PATHS.md")
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 大容量ファイルアーカイブ
archive_large_files() {
    cd "$WORKSPACE_DIR"
    mkdir -p "$ARCHIVE_DIR"
    
    log "🗂️ 大容量ファイルアーカイブ開始"
    
    # 4KB以上のファイルを対象
    find . -maxdepth 2 -name "*.md" -not -path "./node_modules/*" -not -path "./projects/*" -size +4k | while read file; do
        filename=$(basename "$file")
        if ! is_protected_file "$filename"; then
            log "📦 アーカイブ: $file"
            mv "$file" "$ARCHIVE_DIR/"
        fi
    done
}

# メイン処理
main() {
    log "🔥 コンテキスト制限監視開始"
    
    current_size=$(check_current_size)
    log "📊 現在のサイズ: ${current_size}KB (目標: ${TARGET_SIZE_KB}KB以下)"
    
    if [[ $current_size -gt $TARGET_SIZE_KB ]]; then
        log "⚠️ サイズ超過！アーカイブ実行"
        archive_large_files
        
        # 再チェック
        new_size=$(check_current_size)
        log "📊 アーカイブ後: ${new_size}KB"
        
        if [[ $new_size -le $TARGET_SIZE_KB ]]; then
            log "✅ 目標サイズ達成！"
        else
            log "🚨 まだサイズ超過中 - 手動対応必要"
        fi
    elif [[ $current_size -gt $WARNING_SIZE_KB ]]; then
        log "⚠️ 警告レベル - 予防的監視中"
    else
        log "✅ サイズOK - 問題なし"
    fi
    
    log "🔥 コンテキスト制限監視完了"
}

# 実行
main "$@"