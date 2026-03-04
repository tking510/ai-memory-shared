# casino-ranking-jp.com SEO改善調査レポート
**調査日**: 2026-03-03
**現状**: 161ページ中26ページのみインデックス（16%）

---

## 🚨 致命的問題

### 1. サイトマップが404（最重要）
- `robots.txt` が `https://casino-ranking-jp.com/sitemap.xml` を参照
- 実際のファイルは `sitemap-index.xml` → **sitemap.xmlは404**
- **Googleがサイトマップを読めていない** = クロール・インデックスに重大な悪影響
- **修正**: `robots.txt` を `sitemap-index.xml` に変更

### 2. サイトマップにlastmod（最終更新日）がない
- `<lastmod>` タグが一切なし
- Googleがどのページが新しい/更新されたか判断できない
- **修正**: Astro sitemapプラグインの設定で `lastmod` を有効化

---

## ⚠️ 重大問題

### 3. キーワードカニバリゼーション（重複コンテンツ）
同じトピックで複数ページが競合し、Googleがどれをインデックスすべきか判断できない：

| グループ | 重複ページ数 | 例 |
|---|---|---|
| PayPay入金 | 3ページ | paypay-casino-deposit, paypay-casino-deposit-guide, paypay-casino-guide |
| 出金速度 | 3ページ | fast-withdrawal-casino, fast-withdrawal-ranking-2026, online-casino-fast-withdrawal |
| 入金不要ボーナス | 2ページ | no-deposit-bonus-comparison, no-deposit-bonus-latest-2026 |
| 入金方法 | 2ページ | deposit-methods-guide, online-casino-deposit-methods-complete-guide |
| 税金・確定申告 | 2ページ | online-casino-tax-filing-guide, online-casino-tax-japan |
| RTP | 2ページ | slot-rtp-guide, slot-rtp-ranking |
| 仮想通貨カジノ | 2ページ | crypto-casino-guide, crypto-casino-recommended-2026 |
| 安全性・詐欺 | 5ページ | safety-guide, safe-online-casino, security-2026, dangerous-list, scam-warning |
| メンタルスロット | 2ページ | mental-review, mental-slot-review |

**合計: 約25ページが重複** → これだけで全体の19%

### 4. 薄いコンテンツ（Thin Content）
- Sloten系プロモ記事（stepshot, harpina-dreamticket, 100cashback等）が約4.5KB（日本語で約2000文字程度）
- Googleは薄いコンテンツをインデックスしない傾向
- 43記事が2024年の日付 → 古い記事として評価される可能性

---

## 📋 中程度の問題

### 5. 構造化データの不備
- `og:type` が全ページ `website` → ブログ記事は `article` であるべき
- Article構造化データの `author` が全記事「働きマン」固定だが、frontmatterには別名がある

### 6. 画像最適化
- 150枚の画像に対しWebP版は75枚のみ（50%）
- `<picture>` タグで `.webp` を参照しているが、存在しないWebPファイルがある可能性

### 7. hreflang設定が不適切
- 日本語のみのサイトなのに `hreflang="x-default"` と `hreflang="ja"` が同じURLを指す
- 多言語でないなら不要（害はないが冗長）

---

## ✅ 改善施策（優先順位順）

### 即時対応（今すぐ）
1. **robots.txt修正**: `Sitemap: https://casino-ranking-jp.com/sitemap-index.xml`
2. **サイトマップにlastmod追加**: astro.config.mjsでsitemap設定変更
3. **GSCでサイトマップ再送信**

### 1週間以内
4. **重複ページの統合**: 25ページ → 各グループ1ページに統合、残りは301リダイレクト
5. **og:type修正**: ブログ記事ページは `og:type: article` に
6. **薄いコンテンツ強化**: Sloten系プロモ記事を3000文字以上に拡充

### 1ヶ月以内
7. **WebP画像の完全化**: 残り75枚のWebP版を生成
8. **内部リンク強化**: 平均7本は悪くないが、孤立ページがないか確認
9. **古い記事の更新**: 2024年の43記事のdateを更新（内容も見直し）

---

## 📊 改善効果の見込み
- サイトマップ修正だけで **+50〜80ページ** のインデックス増加が期待
- カニバリ解消で **+15〜20ページ** の正常インデックス化
- 合計で **100ページ以上** のインデックスが現実的な目標
