#!/bin/bash
# 🔥 自動圧縮システム（Auto Compaction）- やります君緊急実装
# TK指示: 「とまらんように」「/new を押さなくて済む」システム

# 設定
WORKSPACE_DIR="/Users/ponp/.openclaw/workspace-yarimasu"
MEMORY_DIR="$WORKSPACE_DIR/memory"
SCRIPTS_DIR="$WORKSPACE_DIR/scripts"
BACKUP_DIR="$WORKSPACE_DIR/backups"

# トークン制限設定
MAX_TOKENS=200000
SAFE_THRESHOLD=150000  # 75% で警告
CRITICAL_THRESHOLD=180000  # 90% で緊急圧縮
EMERGENCY_THRESHOLD=195000  # 97.5% で強制圧縮

# ログ関数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# トークン推定（日本語文字は約2トークン、英語単語は約1.3トークン）
estimate_tokens() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "0"
        return
    fi
    
    # 文字数カウント
    local char_count=$(wc -c < "$file" 2>/dev/null || echo "0")
    # 単語数カウント  
    local word_count=$(wc -w < "$file" 2>/dev/null || echo "0")
    # 日本語推定（全体の60%が日本語と仮定）
    local japanese_chars=$((char_count * 60 / 100))
    local english_chars=$((char_count * 40 / 100))
    
    # トークン推定計算
    local estimated_tokens=$(( (japanese_chars * 2 / 3) + (english_chars / 4) + (word_count / 2) ))
    echo "$estimated_tokens"
}

# 全ワークスペーストークン計算
calculate_total_tokens() {
    cd "$WORKSPACE_DIR"
    local total_tokens=0
    
    for file in *.md; do
        if [[ -f "$file" ]]; then
            local tokens=$(estimate_tokens "$file")
            total_tokens=$((total_tokens + tokens))
        fi
    done
    
    echo "$total_tokens"
}

# コア情報バックアップ
backup_core_files() {
    log "💾 コアファイルバックアップ開始"
    mkdir -p "$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"
    local backup_dir="$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"
    
    # 重要ファイルをバックアップ
    for file in SOUL.md USER.md IDENTITY.md MEMORY.md TOOLS.md; do
        if [[ -f "$WORKSPACE_DIR/$file" ]]; then
            cp "$WORKSPACE_DIR/$file" "$backup_dir/"
            log "📦 バックアップ: $file"
        fi
    done
    
    # メモリディレクトリもバックアップ
    if [[ -d "$MEMORY_DIR" ]]; then
        cp -r "$MEMORY_DIR" "$backup_dir/memory_backup"
        log "📦 メモリディレクトリバックアップ完了"
    fi
}

# メモリ圧縮（古いファイルを要約）
compress_memory() {
    log "🗜️ メモリ圧縮開始"
    mkdir -p "$MEMORY_DIR"
    
    # 7日以上前のメモリファイルを圧縮対象に
    local cutoff_date=$(date -d '7 days ago' '+%Y-%m-%d' 2>/dev/null || date -v -7d '+%Y-%m-%d')
    
    cd "$MEMORY_DIR"
    local compressed_content=""
    local compressed_files=0
    
    for file in *.md; do
        if [[ -f "$file" ]]; then
            # ファイル名から日付抽出（YYYY-MM-DD形式）
            if [[ "$file" =~ [0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
                local file_date="${BASH_REMATCH[0]}"
                if [[ "$file_date" < "$cutoff_date" ]]; then
                    log "🗜️ 圧縮対象: $file ($file_date)"
                    
                    # 要約を生成（重要部分のみ抽出）
                    local summary=$(head -20 "$file" | grep -E "^#|^-|^\*|重要|TODO|完了" | head -10)
                    compressed_content+="## $(basename "$file" .md)\n$summary\n\n"
                    
                    # 元ファイルをアーカイブに移動
                    mv "$file" "compressed_$(basename "$file")"
                    compressed_files=$((compressed_files + 1))
                fi
            fi
        fi
    done
    
    if [[ $compressed_files -gt 0 ]]; then
        echo -e "$compressed_content" > "compressed_summary_$(date +%Y%m%d).md"
        log "✅ $compressed_files ファイルを圧縮 → compressed_summary_$(date +%Y%m%d).md"
    fi
}

# 大容量ファイル圧縮
compress_large_files() {
    log "📄 大容量ファイル圧縮開始"
    cd "$WORKSPACE_DIR"
    
    for file in *.md; do
        if [[ -f "$file" && "$file" != "SOUL.md" && "$file" != "USER.md" && "$file" != "IDENTITY.md" ]]; then
            local tokens=$(estimate_tokens "$file")
            
            if [[ $tokens -gt 5000 ]]; then
                log "🗜️ 大容量ファイル圧縮: $file ($tokens tokens)"
                
                # ファイルの重要部分のみ抽出
                local important_content=""
                important_content+="# $(basename "$file" .md) [圧縮版]\n\n"
                
                # 見出し、リスト、重要キーワードを抽出
                important_content+="$(grep -E "^#|^-|^\*|TODO|重要|完了|ERROR|SUCCESS" "$file" | head -30)\n"
                
                # 元ファイルをメモリに移動
                mkdir -p "$MEMORY_DIR"
                mv "$file" "$MEMORY_DIR/original_$file"
                
                # 圧縮版を作成
                echo -e "$important_content" > "$file"
                
                log "✅ $file を圧縮 ($(estimate_tokens "$file") tokens)"
            fi
        fi
    done
}

# 緊急圧縮（最小限のファイルのみ残す）
emergency_compression() {
    log "🚨 緊急圧縮開始 - 最小限ファイルのみ残します"
    
    backup_core_files
    mkdir -p "$MEMORY_DIR"
    cd "$WORKSPACE_DIR"
    
    # 緊急状況をメモリに記録
    local emergency_summary="# 緊急圧縮実行 $(date)\n\n"
    emergency_summary+="## 保護されたファイル\n"
    emergency_summary+="- SOUL.md: $(estimate_tokens "SOUL.md" 2>/dev/null || echo 0) tokens\n"
    emergency_summary+="- USER.md: $(estimate_tokens "USER.md" 2>/dev/null || echo 0) tokens\n" 
    emergency_summary+="- IDENTITY.md: $(estimate_tokens "IDENTITY.md" 2>/dev/null || echo 0) tokens\n"
    
    emergency_summary+="\n## 移動されたファイル\n"
    
    # コアファイル以外をメモリに移動
    for file in *.md; do
        if [[ -f "$file" && "$file" != "SOUL.md" && "$file" != "USER.md" && "$file" != "IDENTITY.md" ]]; then
            local tokens=$(estimate_tokens "$file")
            emergency_summary+="- $file: $tokens tokens\n"
            mv "$file" "$MEMORY_DIR/emergency_backup_$file"
            log "🚨 緊急移動: $file"
        fi
    done
    
    # 緊急状況サマリーを作成
    echo -e "$emergency_summary" > "EMERGENCY_STATUS.md"
    
    log "🚨 緊急圧縮完了 - システム継続可能"
}

# セッション継続フラグ作成
create_session_flag() {
    local current_tokens="$1"
    local action_taken="$2"
    
    cat > "$MEMORY_DIR/session_continuation.md" << EOF
# セッション継続情報 $(date)

## トークン状況
- 圧縮前: $current_tokens tokens
- 実行アクション: $action_taken
- 圧縮後: $(calculate_total_tokens) tokens

## 継続方法
TKには次のように説明:
「自動圧縮システムが作動し、セッションを継続可能にしました。
ファイルはメモリに安全保存されており、必要時に復元できます。」

## 復元コマンド
必要なファイルの復元:
\`\`\`bash
cd $MEMORY_DIR
ls | grep -E "(original_|emergency_backup_)" | head -10
\`\`\`
EOF

    log "📋 セッション継続フラグ作成完了"
}

# メイン処理
main() {
    log "🔥 自動圧縮システム開始"
    
    # ディレクトリ確認・作成
    mkdir -p "$MEMORY_DIR" "$BACKUP_DIR" "$SCRIPTS_DIR"
    
    # 現在のトークン数計算
    local current_tokens=$(calculate_total_tokens)
    log "📊 現在のトークン数: $current_tokens / $MAX_TOKENS"
    
    local action_taken="監視のみ"
    
    if [[ $current_tokens -gt $EMERGENCY_THRESHOLD ]]; then
        log "🚨 緊急レベル ($current_tokens > $EMERGENCY_THRESHOLD) - 緊急圧縮実行"
        emergency_compression
        action_taken="緊急圧縮"
    elif [[ $current_tokens -gt $CRITICAL_THRESHOLD ]]; then
        log "🔴 クリティカル ($current_tokens > $CRITICAL_THRESHOLD) - 積極的圧縮実行"
        compress_large_files
        compress_memory
        action_taken="積極的圧縮"
    elif [[ $current_tokens -gt $SAFE_THRESHOLD ]]; then
        log "🟡 警告レベル ($current_tokens > $SAFE_THRESHOLD) - 軽量圧縮実行"
        compress_memory
        action_taken="軽量圧縮"
    else
        log "✅ 正常範囲内 - 対策不要"
    fi
    
    # セッション継続情報作成
    if [[ "$action_taken" != "監視のみ" ]]; then
        create_session_flag "$current_tokens" "$action_taken"
    fi
    
    # 最終状態確認
    local final_tokens=$(calculate_total_tokens)
    log "📊 処理後トークン数: $final_tokens / $MAX_TOKENS"
    log "💾 メモリファイル数: $(ls -1 "$MEMORY_DIR" 2>/dev/null | wc -l || echo 0)"
    log "🔥 自動圧縮システム完了"
    
    # TK向けレポート生成
    if [[ $final_tokens -lt $SAFE_THRESHOLD ]]; then
        echo "✅ 自動圧縮完了 - セッション継続可能 ($final_tokens tokens)" > "$WORKSPACE_DIR/COMPACTION_STATUS.md"
    fi
}

# 実行
main "$@"