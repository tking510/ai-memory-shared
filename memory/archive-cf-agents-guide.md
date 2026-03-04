# CF Agents Bot ガイド（全エージェント共有）
> 最終更新: 2026-03-03 by やります君

## 概要
Cloudflare Workers上で動くAIチャットBotテンプレート。環境変数を変えるだけで用途別Botを量産できる。

- **技術スタック**: CF Workers + Agents SDK + Durable Objects + Workers AI + React
- **APIキー不要**: Workers AIはCFアカウントにバインドされてるので追加費用・キー管理なし
- **永続稼働**: Durable Objectsで会話履歴を永続化、WebSocketでリアルタイム

---

## インフラ情報
| 項目 | 値 |
|---|---|
| Account ID | `c2e53413ec2e8bca8b9465f2a2fa26dc` |
| プロジェクトパス | `~/projects/agents-starter/` |
| 認証 | `npx wrangler login` でOAuth認証済み |

## 現在稼働中のBot
| Bot名 | Worker名 | URL | プリセット |
|---|---|---|---|
| 🎰 スロット天国 サポート | sloten-chat | https://sloten-chat.koni-tanaka.workers.dev/ | sloten |

---

## 新しいBotをデプロイする手順

### Step 1: wrangler.jsonc を編集

```jsonc
{
    // Worker名 = URLのサブドメインになる
    // https://<name>.koni-tanaka.workers.dev/
    "name": "konibet-chat",  // ← ここを変更

    // ... 他の設定はそのまま ...

    "vars": {
        // 表示名（チャットヘッダーに表示）
        "BOT_NAME": "🎯 コニベット サポート",

        // プリセット名（後述の一覧参照）
        "BOT_PRESET": "konibet",

        // ウェルカムメッセージ
        "WELCOME_TITLE": "コニベットへようこそ！何でもお聞きください",

        // サジェストボタン（JSON配列）
        "SUGGESTIONS": "[\"登録方法は？\",\"入金方法を教えて\",\"ボーナス情報\",\"出金について\"]"
    }
}
```

### Step 2: デプロイ

```bash
cd ~/projects/agents-starter
npm run deploy
```

### Step 3: 完了！
`https://<name>.koni-tanaka.workers.dev/` でアクセス可能。

---

## 環境変数一覧

| 変数名 | 説明 | デフォルト | 必須 |
|---|---|---|---|
| `BOT_NAME` | チャットヘッダーの表示名 | 🎰 スロット天国 サポート | × |
| `BOT_PRESET` | プリセット名 | sloten | × |
| `SYSTEM_PROMPT` | フルカスタムプロンプト（BOT_PRESETより優先） | - | × |
| `AI_MODEL` | Workers AIモデルID | @cf/meta/llama-3.3-70b-instruct-fp8-fast | × |
| `WELCOME_TITLE` | 空チャット時のウェルカムメッセージ | スロット天国へようこそ！... | × |
| `SUGGESTIONS` | サジェストボタン（JSON配列） | おすすめ/入金/出金/初心者 | × |

---

## プリセット一覧

| プリセット | 用途 | 登録リンク |
|---|---|---|
| `sloten` | スロット天国サポート | sloten.io?referral=mOAo |
| `konibet` | コニベットサポート | tracker-pm2.konibet.com |
| `wondercasino` | ワンダーカジノサポート | tracker-pm2.casino-wonder.com |
| `general` | 汎用アシスタント | - |

---

## システムプロンプトのカスタマイズ

### 方法1: プリセットを使う（簡単）
```jsonc
"vars": {
    "BOT_PRESET": "sloten"  // プリセット名を指定するだけ
}
```

### 方法2: フルカスタム（自由度最大）
`SYSTEM_PROMPT` を設定すると `BOT_PRESET` より優先される。

```jsonc
"vars": {
    "BOT_NAME": "🎪 マイカスタムBot",
    "SYSTEM_PROMPT": "あなたは○○の専門AIアシスタントです。\n\n## ルール\n- 日本語で対応\n- 丁寧で簡潔に\n- 知らないことは正直に「分かりません」\n\n## 知識\n- サービスA: 月額1000円\n- サービスB: 月額2000円\n- 問い合わせ: support@example.com",
    "WELCOME_TITLE": "○○へようこそ！",
    "SUGGESTIONS": "[\"料金を教えて\",\"始め方は？\",\"サポートに連絡\"]"
}
```

### 方法3: プリセットを追加する（開発者向け）
`src/server.ts` の `PROMPT_PRESETS` オブジェクトに新しいキーを追加：
```typescript
const PROMPT_PRESETS: Record<string, string> = {
    sloten: `...`,
    konibet: `...`,
    // ↓ 新規追加
    newbrand: `あなたは「NewBrand」のサポートです。...`,
};
```
追加後 `npm run deploy` で反映。

---

## AIモデルの変更

```jsonc
"vars": {
    "AI_MODEL": "@cf/meta/llama-3.1-8b-instruct-fast"
}
```

| モデル | 特徴 | おすすめ用途 |
|---|---|---|
| `@cf/meta/llama-3.3-70b-instruct-fp8-fast` | 高品質（デフォルト） | 本番サポート |
| `@cf/meta/llama-3.1-8b-instruct-fast` | 軽量・高速 | テスト・軽い用途 |
| `@cf/zai-org/glm-4.7-flash` | 多言語対応 | 英語対応が必要な場合 |

---

## ウィジェット埋め込み

### 最小構成（1行）
任意のHTMLページの `</body>` 前に追加：
```html
<script src="https://sloten-chat.koni-tanaka.workers.dev/widget.js" defer></script>
```
→ 右下に🎰ボタンが出現、クリックでチャット展開。

### カスタマイズ付き
```html
<script>
window.SLOTEN_CHAT = {
    src: 'https://sloten-chat.koni-tanaka.workers.dev/',  // Bot URL
    icon: '💬',        // ボタンアイコン（絵文字）
    color: '#E2421F',  // ボタン背景色
    position: 'right', // right or left
    size: 60,          // ボタンサイズ(px)
    width: 380,        // チャット幅(px)
    height: 540        // チャット高さ(px)
};
</script>
<script src="https://sloten-chat.koni-tanaka.workers.dev/widget.js" defer></script>
```

### 別Botのウィジェットを使う場合
`src` を別WorkerのURLに変えるだけ：
```html
<script>
window.SLOTEN_CHAT = {
    src: 'https://konibet-chat.koni-tanaka.workers.dev/',
    icon: '🎯',
    color: '#1E88E5'
};
</script>
<script src="https://sloten-chat.koni-tanaka.workers.dev/widget.js" defer></script>
```

### ウィジェットの特徴
- 📦 scriptタグ1行で導入
- 🎨 色・位置・サイズ完全カスタマイズ
- 📱 モバイルレスポンシブ対応
- ⚡ 遅延読み込み（クリックまでiframeロードしない）
- 🎬 フェードインアニメーション
- 🔒 iframe sandbox（安全）

---

## CF API Token / Account ID の設定

### 認証方法（推奨: OAuth）
```bash
npx wrangler login
# ブラウザが開くのでGoogleアカウントでログイン
# 自動的にOAuthトークンが保存される
```

### API Tokenを使う場合
```bash
# 環境変数で設定
export CLOUDFLARE_API_TOKEN="CsceQi5eC1Cw2t5KOGQcE40w1Q3YXg6lsZrFiBq2"
export CLOUDFLARE_ACCOUNT_ID="c2e53413ec2e8bca8b9465f2a2fa26dc"

# または wrangler.jsonc に直接（非推奨）
# secretsを使うのが安全
npx wrangler secret put CLOUDFLARE_API_TOKEN
```

### Account IDの確認
```bash
npx wrangler whoami
# → Account Name / Account ID が表示される
```

---

## トラブルシューティング

| 症状 | 対処 |
|---|---|
| デプロイ時に503 | CF Pages APIが不安定な時がある。数分待ってリトライ |
| チャットが英語で返答 | `BOT_PRESET`または`SYSTEM_PROMPT`に日本語指示があるか確認 |
| ウィジェットが表示されない | scriptタグが`</body>`前にあるか確認。コンソールでエラーチェック |
| 「Disconnected」表示 | WebSocket接続が切れた。ページリロードで復帰 |
| wrangler.jsoncパースエラー | JSONCのカンマ忘れ。各オブジェクトの後にカンマがあるか確認 |

---

## ファイル構成
```
~/projects/agents-starter/
├── wrangler.jsonc        # Worker設定（name, vars）
├── src/
│   ├── server.ts         # バックエンド（プロンプト、ツール、API）
│   ├── app.tsx           # フロントエンド（React UI）
│   ├── client.tsx        # Reactエントリポイント
│   └── styles.css        # スタイル
├── public/
│   └── widget.js         # 埋め込みウィジェットスクリプト
├── index.html            # HTMLテンプレート
├── DEPLOY-GUIDE.md       # デプロイガイド（詳細版）
└── package.json
```
