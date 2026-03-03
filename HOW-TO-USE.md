# 🧠 AI Memory Repository 使用方法

## 🎯 **TKからの指示**
全エージェントは以下の手順でAI Memory Repositoryを使用すること。
**記憶が飛ぶことを完全に防ぐシステム**です。

---

## 📍 **場所**
```bash
/Users/ponp/.openclaw/workspace/ai-memory-shared/
```

## ⚡ **基本ルール (絶対遵守)**

### 1. **5分ごと**: 必ず最新情報を確認
```bash
cd /Users/ponp/.openclaw/workspace/ai-memory-shared
git pull origin main
```

### 2. **作業開始時**: 必ず現状確認
- `current-tasks.md` - 全員のタスク状況
- `task-coordination.md` - 助け合い・ブロック状況  
- `project-status.md` - プロジェクト全体状況

### 3. **作業完了時**: 必ず情報更新
```bash
# ファイルを編集後
git add .
git commit -m "[エージェント名] 作業内容 - $(date '+%Y-%m-%d %H:%M')"
git push origin main
```

---

## 📁 **ファイル構成と役割**

### 🔥 **必読ファイル** (毎回確認)
- **current-tasks.md** - 全員の現在タスク、連携状況
- **task-coordination.md** - 助け合い・依存関係・ブロック状況

### 📊 **参照ファイル** (必要時確認)  
- **project-status.md** - プロジェクト全体状況
- **tools-urls.md** - 重要URL集 (永続デプロイ版)
- **logs-paths.md** - 編集時必要パス情報
- **created-tools.md** - 制作物リスト・最新状況
- **decisions.md** - 重要な決定事項
- **daily-log.md** - 日次作業ログ

---

## 🔄 **作業フロー例**

### 💪 **作業開始時**
1. `cd /Users/ponp/.openclaw/workspace/ai-memory-shared`
2. `git pull origin main` (最新情報取得)
3. `current-tasks.md` で自分の状況確認
4. `task-coordination.md` で助け合い状況確認
5. ブロックや依存があれば解決または報告

### 🔥 **作業中**
- 他エージェントから支援要請 → `task-coordination.md` 確認
- ブロック発生 → 即座に `current-tasks.md` 更新
- 重要な決定 → `decisions.md` 記録

### ✅ **作業完了時**
1. 該当ファイルを更新 (current-tasks.md等)
2. `git add . && git commit -m "[自分] 作業完了内容" && git push`
3. 他エージェントに影響する変更は通知

---

## 🚨 **重要な注意点**

### ✅ **必須行動**
- 5分ごとの `git pull` は絶対実行
- 作業完了時の更新は必須
- ブロック状況は即座報告

### ❌ **禁止行動**  
- Git操作をしないでファイル編集
- 他エージェントのタスク情報を削除
- 同期なしでの長時間作業

---

## 💡 **具体的な更新例**

### current-tasks.md 更新例
```markdown
### 🔥 やります君
- **タスク名** (完了 ✅ / 進行中 / ブロック中)
- **詳細**: 具体的な作業内容
- **依存**: 誰の作業待ち (ある場合)
- **次回**: 次のアクション予定
```

### task-coordination.md 更新例
```markdown
#### 新規ブロック
- **ブロック内容**: 具体的な問題
- **原因**: なぜブロックされているか  
- **解決者**: 誰が解決するか
- **期限**: いつまでに解決予定か
```

---

## 🎉 **効果**
- ✅ **記憶永続化**: セッション切れても完全復元
- ✅ **情報共有**: 全員の状況リアルタイム把握  
- ✅ **効率化**: 重複作業なし、助け合い最適化
- ✅ **品質向上**: ブロック即座解決、優先度明確

---

**このシステムで記憶が飛ぶことは二度とありません！** 🧠💪

**質問・不明点があればTKまたは働きマンに確認してください。**