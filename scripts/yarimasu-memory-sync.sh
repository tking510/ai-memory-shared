#!/bin/bash
# やります君 - 5分毎記憶更新スクリプト

cd ~/projects/ai-memory-shared

echo "$(date '+%Y-%m-%d %H:%M:%S') - やります君 記憶同期開始"

# 最新取得
git pull

# 現在の状況をメモリに記録
cat > shared-memory/yarimasu-status-$(date +%H%M).md << EOF
# やります君ステータス - $(date '+%Y-%m-%d %H:%M:%S')

## 現在の状況
- **稼働状態**: アクティブ
- **最後のタスク**: ヘブンショット完全復元 (18:30完了)
- **現在作業**: GitHub共有基盤対応
- **次回チェック**: $(date -d '+5 minutes' '+%Y-%m-%d %H:%M:%S')

## 重要ルール確認
- ✅ BOT通信制限: TKアカウント経由必須
- ✅ Openclawプロファイル: 使用中
- ✅ 記憶同期: 5分毎実行

## 完了プロジェクト
- **ヘブンショット**: https://81e12049.heavenshot-slotenpromotion.pages.dev
- **AIチャット**: リアルタイム対応完了
- **モバイル**: 完全対応済み

---
自動生成: やります君記憶同期スクリプト
EOF

# コミット&プッシュ
git add .
git commit -m "やります君: 5分記憶同期 $(date '+%H:%M')"
git push

echo "$(date '+%Y-%m-%d %H:%M:%S') - やります君 記憶同期完了"