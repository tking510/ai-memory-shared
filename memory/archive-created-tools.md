# 🛠️ 制作物リスト (最新デプロイ版)

## 📅 最終更新: 2026-03-04 02:49 GMT+8

### 🎯 **メインツール (永続デプロイ済み)**

#### プロモーション・マーケティング系
- **プロモファクトリー**
  - 本番URL: https://promo.slotenpromotion.com
  - 機能: プロモバナー/メール/LP/SNSコピー/規約一括生成
  - 技術: Cloudflare Pages + Workers
  - 状態: ✅ 永続稼働中

- **ビジネスダッシュボード**  
  - 本番URL: https://dashboard.slotenpromotion.com
  - パスワード: Sloten1234
  - 機能: 事業別監視、カジノ統計、累積マージ対応
  - 状態: ✅ 永続稼働中、3月データ対応済み

- **AIオフィス**
  - 本番URL: https://office.slotenpromotion.com
  - 機能: 8人AI配置、雑談チャット、会議モード
  - 状態: ✅ 永続稼働中

- **3D VIPルーム**
  - 本番URL: https://vip.slotenpromotion.com  
  - 機能: Three.js 3Dカジノルーム、スロット5台、7ブランド表示
  - 状態: ✅ 永続稼働中

#### 分析・管理系
- **FTDチェッカー**
  - 本番URL: https://ftdchecher.slomanga.com
  - 機能: FTD・登録チェック
  - 状態: ✅ 稼働中

- **FTD分析ツール**  
  - 本番URL: https://ftd-analyzer.pages.dev
  - 機能: FTD分析・統計
  - 状態: ✅ 稼働中

- **SMSダッシュボード**
  - 本番URL: https://sms.xr7k.com
  - 機能: SMS/メール配信データ分析
  - 状態: ✅ 稼働中

- **クロークシステム**
  - 本番URL: https://ct.slotenpromotion.com/admin
  - トークン: cloak-admin-2026
  - 機能: CSV一括登録、トラッキング、フィルター管理
  - 状態: ✅ 稼働中

#### SEO・コンテンツサイト
- **casino-ranking-jp.com**
  - 本番URL: https://casino-ranking-jp.com
  - 機能: オンカジランキング、毎日自動SEO
  - ページ数: 161 (26インデックス済み)
  - 状態: ✅ 稼働中、SEO改善実施済み

- **cajikomi.com**
  - 本番URL: https://cajikomi.com  
  - 機能: スロ天口コミ・評判サイト
  - 状態: ✅ 稼働中

#### カジノ・ゲーム本体
- **VVV (vvvgame.io)**
  - 本番URL: https://vvvgame.io
  - 機能: クリプトカジノ、14ゲーム、6チェーン対応
  - 技術: Next.js + NestJS + Prisma
  - 状態: ✅ 本番稼働中

- **スロ天 (sloten.io)**
  - 本番URL: https://sloten.io  
  - X: @sloten777
  - 状態: ✅ 本番稼働中

### 🚧 **開発中・テスト版**

#### ゲーム系 (開発完了、URL要確認)
- **野球ハンデ/ベット** (~/projects/baseball-bet/)
- **オンラインパチンコ** (~/projects/pachislot-simulator/) 
- **東京レンディング** (~/projects/tokyo-lending/)
- **バカラトーナメント** (grand-baccarat.pages.dev)

### 🗂️ **プロモLP集**
- **sloten-promos.pages.dev** (profitshare/prediction/mission/)
- **credit-casino-promos.pages.dev** (lossback/credit-share/free-credit/)
- **hinamatsuri-promo.pages.dev** (ひな祭りスペシャル、終了)

### 📊 **統計**
- **永続デプロイ済み**: 12ツール
- **slotenpromotion.com統一**: 4メインツール  
- **開発完了**: 4ゲーム系
- **総制作物**: 20+

### 🔧 **開発・デプロイパス**
```bash
# メインプロジェクト
~/projects/promo-factory/         # プロモファクトリー
~/projects/business-dashboard/    # ビジネスダッシュボード
~/projects/ai-office/             # AIオフィス  
~/projects/vip-room-3d/           # 3D VIPルーム

# デプロイコマンド例
cd ~/projects/promo-factory && npm run deploy
```