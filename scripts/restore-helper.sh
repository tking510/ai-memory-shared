#!/bin/bash
# 🔄 復元ヘルパースクリプト - やります君作成
# 自動圧縮されたファイルの復元用

WORKSPACE_DIR="/Users/ponp/.openclaw/workspace-yarimasu"
MEMORY_DIR="$WORKSPACE_DIR/memory"
BACKUP_DIR="$WORKSPACE_DIR/backups"

# ログ関数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 利用可能なバックアップファイル一覧
list_available() {
    echo "🔍 復元可能なファイル一覧:"
    echo
    
    if [[ -d "$MEMORY_DIR" ]]; then
        echo "📁 メモリアーカイブ:"
        cd "$MEMORY_DIR"
        ls -la | grep -E "(original_|emergency_backup_|archive-)" | head -20
        echo
    fi
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "💾 バックアップディレクトリ:"
        find "$BACKUP_DIR" -name "*.md" | head -10
        echo
    fi
    
    echo "🔧 使用方法:"
    echo "  $0 restore <ファイル名>     # 特定ファイル復元"
    echo "  $0 restore-latest         # 最新バックアップから復元"
    echo "  $0 emergency-restore      # 緊急時の最小復元"
}

# 特定ファイル復元
restore_file() {
    local filename="$1"
    
    if [[ -z "$filename" ]]; then
        echo "❌ ファイル名を指定してください"
        list_available
        return 1
    fi
    
    log "🔄 ファイル復元開始: $filename"
    
    # メモリから検索
    if [[ -f "$MEMORY_DIR/original_$filename" ]]; then
        cp "$MEMORY_DIR/original_$filename" "$WORKSPACE_DIR/$filename"
        log "✅ 復元完了: original_$filename → $filename"
        return 0
    fi
    
    if [[ -f "$MEMORY_DIR/emergency_backup_$filename" ]]; then
        cp "$MEMORY_DIR/emergency_backup_$filename" "$WORKSPACE_DIR/$filename"
        log "✅ 復元完了: emergency_backup_$filename → $filename"
        return 0
    fi
    
    if [[ -f "$MEMORY_DIR/archive-$filename" ]]; then
        cp "$MEMORY_DIR/archive-$filename" "$WORKSPACE_DIR/$filename"
        log "✅ 復元完了: archive-$filename → $filename"
        return 0
    fi
    
    log "❌ $filename が見つかりません"
    list_available
}

# 最新バックアップから復元
restore_latest() {
    log "🔄 最新バックアップから復元開始"
    
    # 最新のバックアップディレクトリを見つける
    local latest_backup=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "20*" | sort | tail -1)
    
    if [[ -z "$latest_backup" ]]; then
        log "❌ バックアップが見つかりません"
        return 1
    fi
    
    log "📦 最新バックアップ: $(basename "$latest_backup")"
    
    # コアファイルを復元
    for file in SOUL.md USER.md IDENTITY.md MEMORY.md TOOLS.md; do
        if [[ -f "$latest_backup/$file" ]]; then
            cp "$latest_backup/$file" "$WORKSPACE_DIR/"
            log "✅ 復元: $file"
        fi
    done
    
    log "✅ 最新バックアップからの復元完了"
}

# 緊急復元（最小限）
emergency_restore() {
    log "🚨 緊急復元開始"
    
    # 必須ファイルのみ復元
    for file in SOUL.md USER.md IDENTITY.md; do
        if [[ -f "$MEMORY_DIR/emergency_backup_$file" ]]; then
            cp "$MEMORY_DIR/emergency_backup_$file" "$WORKSPACE_DIR/$file"
            log "🚨 緊急復元: $file"
        elif [[ -f "$MEMORY_DIR/original_$file" ]]; then
            cp "$MEMORY_DIR/original_$file" "$WORKSPACE_DIR/$file"
            log "🚨 緊急復元: $file"
        fi
    done
    
    # 緊急状況を記録
    echo "# 緊急復元実行 $(date)" > "$WORKSPACE_DIR/RESTORE_STATUS.md"
    echo "最小限のファイルを復元しました。" >> "$WORKSPACE_DIR/RESTORE_STATUS.md"
    echo "完全復元が必要な場合は restore-latest を実行してください。" >> "$WORKSPACE_DIR/RESTORE_STATUS.md"
    
    log "🚨 緊急復元完了"
}

# 状況確認
status() {
    log "📊 復元システム状況"
    
    echo "💾 ワークスペース (.md ファイル):"
    cd "$WORKSPACE_DIR"
    ls -la *.md 2>/dev/null | head -10 || echo "  ファイルなし"
    echo
    
    echo "📁 メモリアーカイブ:"
    if [[ -d "$MEMORY_DIR" ]]; then
        echo "  ファイル数: $(ls -1 "$MEMORY_DIR" 2>/dev/null | wc -l)"
        echo "  最新: $(ls -t "$MEMORY_DIR" 2>/dev/null | head -1)"
    else
        echo "  メモリディレクトリなし"
    fi
    echo
    
    echo "💾 バックアップ:"
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "  バックアップ数: $(ls -1 "$BACKUP_DIR" 2>/dev/null | wc -l)"
        echo "  最新: $(ls -t "$BACKUP_DIR" 2>/dev/null | head -1)"
    else
        echo "  バックアップなし"
    fi
}

# メイン処理
main() {
    local command="$1"
    local filename="$2"
    
    case "$command" in
        "list"|"ls"|"")
            list_available
            ;;
        "restore")
            restore_file "$filename"
            ;;
        "restore-latest")
            restore_latest
            ;;
        "emergency-restore")
            emergency_restore
            ;;
        "status")
            status
            ;;
        *)
            echo "🔧 復元ヘルパースクリプト - 使用方法:"
            echo "  $0 list                   # 復元可能ファイル一覧"
            echo "  $0 restore <ファイル名>    # 特定ファイル復元"
            echo "  $0 restore-latest         # 最新バックアップから復元"  
            echo "  $0 emergency-restore      # 緊急時の最小復元"
            echo "  $0 status                 # 状況確認"
            ;;
    esac
}

# 実行
main "$@"