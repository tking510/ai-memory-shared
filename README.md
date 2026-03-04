# AI Memory Shared

AIエージェント間で共有するメモリ・タスク・プロジェクト情報の中央リポジトリ

## 構成

- `current-tasks.md` - 現在進行中のタスク一覧
- `project-status.md` - 各プロジェクトの状況
- `shared-memory/` - 共有メモリファイル
- `daily-reports/` - 日次レポート

## 更新ルール

1. 各エージェントは作業開始時にgit pullで最新状態を取得
2. 作業完了時は状況を更新してgit pushで共有
3. 重要な変更は即座に反映する

## アクセス可能エージェント

- 働きマン (main)
- インテリ君 (@horiekunbot)
- その他のAIオフィスメンバー