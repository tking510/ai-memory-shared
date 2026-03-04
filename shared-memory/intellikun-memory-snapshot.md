# MEMORY.md - インテリ君の長期記憶

## 俺について
- 名前: インテリ君（最初は堀江君だった）
- 絵文字: ⚡
- Telegram bot: @horiekunbot（ユーザー名変更不可）、表示名 intellikun
- バイブス: カジュアル日本語、タメ口

## TKについて
- 黒田 貴志 (Kuroda Takashi)
- GMT+8
- Telegram: @TK77777TK
- めんどくさがり → 俺が動けることは俺がやる
- オンラインカジノ事業（スロ天 sloten.io）運営
- 個人運営: cajikomi.com（カジコミ）、casino-ranking-jp.com

## 仲間
- **働きマン** (@hatarakimanbot): TKのもう一体のAIエージェント。SNS運用、バナー制作、サイト管理、VVV開発担当。マシンは /Users/ponp/（別マシン）

## Telegramグループ
- `-5255488789` — 働きマン労働所
- `-5251989074` — (名前不明)
- `-5195461027` — ペイメント
- 全グループ: requireMention: true, groupPolicy: open

## インフラ
- 全部Cloudflare Pages（サーバーレス）、VPSなし
- CF Account: c2e53413ec2e8bca8b9465f2a2fa26dc (koni.tanaka@gmail.com)
- 詳細: memory/infrastructure.md
- 🔐 全ログイン情報: memory/credentials.md

## VVV (vvvgame.io)
- Tech: Next.js 14 + NestJS + Prisma v7 + Neon + Upstash Redis
- BO: https://admin.vvvgame.io/admin (VVVadmin / VVV1234)

## スロ天キャラクター
- **リリシア (Lilicia)** — 悪魔系女の子。紫/マゼンタ髪、角、コウモリ羽、赤い目。紫ドレス+金ベルト
- **セレフィム (Celephim)** — 天使系女の子。金髪、ヘイロー、白い羽、青い目。竪琴持ち。水色ドレス
- **ルシフィーレ (Lucifire)** — 堕天使/ダーク系。黒フード+金の縁取り、赤い目、灰色の羽、炎エフェクト。赤いペンダント
- **ラフィエル (Rafiel)** — 天使/僧侶系。緑フード+金ローブ、ヘイロー、水色の羽、目を閉じてる。本を持ってる
- **ゲートリアン (Gaterian)** — 天使騎士系男の子。黒髪短髪、ヘイロー、白い羽、銀の鎧、槍持ち。門番っぽい
- **アークエル (Arquel)** — 金髪天使男の子、炎の剣、金鎧、ヘイロー（ちびキャラ風）
- **ハルピナ (Harpina)** — 水色髪天使女の子、トランペット、白ドレス、ヘイロー（ちびキャラ風）
- キャラ素材: workspace/march-calendar/chars/ に保存済み
- ちびキャラ風素材はTKから直接送られてきた（太線アウトライン、デフォルメスタイル）

## チーム
- TK = X・統括
- 高木 = Telegram運用
- 太田 = Discord運用
- 働きマン = AI (TK Mac @hatarakimanbot)
- インテリ君 = AI (別マシン @horiekunbot)

## サイト一覧
- 詳細: memory/tk-sites.md

## Sloten BO
- URL: https://admin.sloten.io/
- Login: admin / ADMIN2024
- Verification Code(CAPTCHA)あり、画像読み取りで突破可能

## 開発管理
- 開発管理スプレッドシート: https://docs.google.com/spreadsheets/d/1ao5FPPJVAl3vKGCkUmu8xhu0tHpSKQghME1OVhSF1p4/
- 開発チーム: ATHENA(中国側開発), キン(PM), Richie(りゅういちさん、運営側窓口)
- 春節は毎年開発停止（2026年は〜2/24）
- 開発依頼チャットグループ: 「Sloten 開発＆オペ」「Sloten CS＆オペ&開発」「開発依頼用」

## VIPシステム（2026-02-24〜）
- 30レベル制: Bronze〜Obsidian × 各5サブレベル = 30段階
- BOでmin/max入力 → 自動按分（キャッシュバック率、リベート率、昇格条件）
- VipTierEnum廃止 → VipTierテーブル（id管理）
- キャッシュバック/リベート率はVIPレベルで自動決定
- ユーザーは配分スプリット（daily/weekly/monthly%）のみ選択
- デプロイ注意: 本番のprisma/schema.prismaはsudoersで直接cp不可、hook経由必須

## TKの電話番号
- Malaysia: +60 1161530726
- Japan: +81 80-1970-8358

## Zadarma (ジョージア番号)
- アカウント: koni.tanaka@gmail.com / Zadarma_Reach2026!
- 目的: ジョージア+995番号取得→日本番号に転送
- National番号: $4/月
- ステータス: $20チャージ待ち（カードdeclined→再試行必要）

## Discord AIオフィス
- Bot: discord-office/bot.js（ポーリング式）
- 3チャンネルWebhook: オフィス雑談/タスクボード/進捗報告
- OpenClaw API連携未完（405エラー）

## note.com
- gambuuuuulアカウント: BAN済み、7記事全消失
- slottengokuアカウント: 生存（ログイン情報不明）
- 代替: はてなブログ開設申請中

## SEO運用ルール
- 毎日のSEO定期タスクで優先作業（404修正、再ビルド＆デプロイ等）が見つかった場合は **許可なしで即対応** する（2026-03-02 TK承認済み）
- 対応後に結果報告はする

## 教訓
- **マルチエージェント追加時の注意**: `openclaw channels add`で新Telegramアカウント追加すると、メイン(default)のbotTokenがdefault accountに正しく入らない場合がある。追加後に必ずconfigのdefault accountのbotToken設定を確認すること！（2026-03-02 やらかし: ポーリング停止→TKが手動修正）
- Telegram botのユーザー名は作成後変更不可
- グループ追加時はチャットID必須（allowlistに入れないとメッセージが届かない）
- TKはめんどくさがりなので、できることは全部俺がやる
- GitHub認証がこのマシンにないのでpushにはPAT必要
- BOのAffiliate ReportsのLevel 1 Usersは全期間累計、期間フィルター効かない
- User ListにAFF経由の列がない → 開発依頼済み
