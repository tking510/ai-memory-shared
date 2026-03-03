# 📂 ログパス・編集対象パス集

## 📅 最終更新: 2026-03-04 02:48 GMT+8

### 🔧 **OpenClaw システムパス**

#### 設定・ログファイル
```bash
# OpenClaw本体
~/.openclaw/openclaw.yaml          # メイン設定
~/.openclaw/workspace/            # 作業ディレクトリ
~/.openclaw/workspace/memory/     # 日次メモリ
/opt/homebrew/lib/node_modules/openclaw/  # OpenClawインストール

# エージェント設定
~/.openclaw/workspace/AGENTS.md   # エージェント設定
~/.openclaw/workspace/SOUL.md     # ペルソナ設定
~/.openclaw/workspace/TOOLS.md    # ツール情報
~/.openclaw/workspace/USER.md     # ユーザー情報
~/.openclaw/workspace/HEARTBEAT.md # heartbeat設定

# AI Memory (統一版)
/Users/ponp/.openclaw/workspace/ai-memory-shared/  # ←これ！
```

#### プロジェクトパス
```bash
# メインプロジェクト
~/projects/                       # プロジェクトルート
~/projects/promo-factory/         # プロモファクトリー
~/projects/business-dashboard/    # ビジネスダッシュボード  
~/projects/ai-office/             # AIオフィス
~/projects/casino-ranking-jp/     # casino-ranking-jp.com
~/projects/vip-room-3d/           # 3D VIPルーム

# スクリプト
~/scripts/                        # 自動化スクリプト
~/scripts/update_sns_sheet.py     # SNS管理シート更新
~/scripts/ig_post_reel.py         # Instagram投稿
```

### 🌐 **デプロイ・管理URL**

#### Cloudflare Pages管理
```
https://dash.cloudflare.com/
Account ID: c2e53413ec2e8bca8b9465f2a2fa26dc
API Token: CsceQi5eC1Cw2t5KOGQcE40w1Q3YXg6lsZrFiBq2
```

#### GitHub管理
```
https://github.com/settings/tokens  # Personal Access Token管理
```

### 📊 **ログファイル場所**

#### システムログ
```bash
# OpenClaw
~/.openclaw/logs/                  # OpenClawログ
/var/log/openclaw/                # システムレベルログ

# Cron
/var/log/cron                     # cronジョブログ
```

#### 業務ログ  
```bash
# AI Memory (今回の場所)
/Users/ponp/.openclaw/workspace/ai-memory-shared/daily-log.md
/Users/ponp/.openclaw/workspace/ai-memory-shared/sync-log.md

# 従来のメモリ
~/.openclaw/workspace/memory/YYYY-MM-DD.md
~/.openclaw/workspace/MEMORY.md
```

### 🔑 **認証・設定ファイル**

#### API Keys
```bash
# 環境変数ファイル
~/projects/promo-factory/.env     # Gemini API等
~/.bash_profile                   # 環境変数設定
~/.zshrc                          # zsh環境変数
```

#### SSH・Git
```bash
~/.ssh/id_rsa                     # SSH秘密鍵
~/.ssh/known_hosts                # SSH既知ホスト
~/.gitconfig                      # Git設定
```