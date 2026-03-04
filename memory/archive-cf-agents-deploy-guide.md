# CF Agents Bot テンプレート デプロイガイド

## 概要
Cloudflare Workers + Agents SDK で動くAIチャットボットのテンプレート。
環境変数を変えるだけで、用途別のBotを量産できる。

## 現在稼働中のBot
| Bot名 | Worker名 | URL | プリセット |
|---|---|---|---|
| スロット天国 サポート | sloten-chat | https://sloten-chat.koni-tanaka.workers.dev/ | sloten |

## アーキテクチャ
- **バックエンド**: Cloudflare Workers + Agents SDK + Durable Objects
- **フロントエンド**: Vite + React + Kumo UI
- **AI**: Workers AI（APIキー不要）
- **永続化**: Durable Objects (SQLite)
- **通信**: WebSocket（リアルタイム）

## 新しいBotをデプロイする手順

### 方法1: 環境変数だけ変える（同じWorkerで切り替え）
```bash
cd ~/projects/agents-starter

# wrangler.jsonc の vars セクションを編集
# BOT_PRESET を変更するだけ
npm run deploy
```

### 方法2: 新しいWorkerとして別名デプロイ（推奨）
```bash
cd ~/projects/agents-starter

# 1. wrangler.jsonc の "name" を変更
#    例: "konibet-chat", "wonder-chat"

# 2. vars を変更
#    BOT_NAME: 表示名
#    BOT_PRESET: プリセット名 (sloten|konibet|wondercasino|general)
#    または SYSTEM_PROMPT: フルカスタムプロンプト

# 3. デプロイ
npm run deploy

# 4. 完了！ https://<name>.koni-tanaka.workers.dev/ でアクセス
```

### 方法3: 完全カスタムプロンプト
```bash
# wrangler.jsonc の vars に SYSTEM_PROMPT を設定
# BOT_PRESETより優先される
"vars": {
    "BOT_NAME": "🎯 マイBot",
    "SYSTEM_PROMPT": "あなたは○○の専門家です。...",
    "WELCOME_TITLE": "○○へようこそ！",
    "SUGGESTIONS": "[\"質問1\",\"質問2\",\"質問3\"]"
}
```

## 環境変数一覧
| 変数名 | 説明 | デフォルト |
|---|---|---|
| `BOT_NAME` | チャットヘッダーの表示名 | 🎰 スロット天国 サポート |
| `BOT_PRESET` | プリセット名 | sloten |
| `SYSTEM_PROMPT` | フルカスタムプロンプト（BOT_PRESETより優先） | - |
| `AI_MODEL` | Workers AIモデルID | @cf/meta/llama-3.3-70b-instruct-fp8-fast |
| `WELCOME_TITLE` | 空チャット時のウェルカムメッセージ | スロット天国へようこそ！... |
| `SUGGESTIONS` | サジェストボタン（JSON配列） | おすすめ/入金/出金/初心者 |

## プリセット一覧
| プリセット | 用途 |
|---|---|
| `sloten` | スロット天国サポート |
| `konibet` | コニベットサポート |
| `wondercasino` | ワンダーカジノサポート |
| `general` | 汎用アシスタント |

## LPへの埋め込み
HTMLの `</body>` 前に以下を追加：
```html
<button id="chat-btn" onclick="document.getElementById('chat-frame').style.display=document.getElementById('chat-frame').style.display==='block'?'none':'block'" style="position:fixed;bottom:24px;right:24px;width:60px;height:60px;border-radius:50%;background:#D4A017;border:none;cursor:pointer;z-index:9999;font-size:28px">🎰</button>
<iframe id="chat-frame" src="https://sloten-chat.koni-tanaka.workers.dev/" style="position:fixed;bottom:96px;right:24px;width:380px;height:520px;border:none;border-radius:16px;box-shadow:0 8px 40px rgba(0,0,0,0.25);z-index:9998;display:none"></iframe>
```

## AIモデル候補
| モデル | 特徴 |
|---|---|
| `@cf/meta/llama-3.3-70b-instruct-fp8-fast` | 高品質・推奨（デフォルト） |
| `@cf/meta/llama-3.1-8b-instruct-fast` | 軽量・高速 |
| `@cf/zai-org/glm-4.7-flash` | 多言語対応 |
| `@cf/google/gemma-7b-it-lora` | コンパクト |

## インフラ情報
- Cloudflare Account: c2e53413ec2e8bca8b9465f2a2fa26dc
- プロジェクトパス: ~/projects/agents-starter/
- API Token: wrangler loginで認証済み（OAuthトークン）
