# MEMORY.md - やります君 長期記憶

## プロジェクト情報
| プロジェクト | パス | デプロイ | URL |
|---|---|---|---|
| promo-factory | ~/projects/promo-factory/public/ | `npx wrangler pages deploy public --project-name=promo-factory` | https://promo-factory.pages.dev |
| ai-office | ~/projects/ai-office/ | `npx wrangler pages deploy . --project-name ai-office-b7s` | https://ai-office-b7s.pages.dev |
| casino-ranking-jp | ~/projects/casino-ranking-jp/ | `npm run build && npx wrangler pages deploy dist --project-name=casino-ranking-jp --commit-dirty=true` | https://casino-ranking-jp.com |
| cajikomi | ~/projects/cajikomi/ | `npm run build && npx wrangler pages deploy dist --project-name=cajikomi --commit-dirty=true` | https://cajikomi.com |
| heavenshot-slotenpromotion | ~/projects/heavenshot-slotenpromotion/ | `npx wrangler pages deploy . --project-name=heavenshot-slotenpromotion` | https://1e6308d5.heavenshot-slotenpromotion.pages.dev |

## casino-ranking-jp.com
- Astro 4.16.19, 120 blog articles, 129 built pages
- BaseLayout: src/layouts/BaseLayout.astro, blog template: src/pages/blog/[...slug].astro
- Content collection: src/content/blog/
- Article + FAQ + Breadcrumb structured data
- GSC: koni.tanaka@gmail.com, URL prefix property
- 2026-03-03: インデックス34/137, 表示急増中

## cajikomi.com
- Astro 5.x, 8 pages (index + 8 articles), CTR 19.8%
- GSC: 3 indexed / 26 not indexed, 30 clicks
- 2026-03-03: サイトマップ・robots.txt追加済み

## sloten_data
- KPI: sheet1.xlsx タブ202602 (月次KPI全データ)
- 広告: sheet2.xlsx (Meta広告4アカウント)
- ツール: sheet3.xlsx (バカラツール等)
- 顧客: sheet6_kokyaku_list_d.csv (信用枠顧客794人)
- コニベット: sheet7_konibet.csv
- SMS: sms_ninshou_mapped.csv (1,663行、特定キャンペーン送信ログ)

## 連絡先
- AIオフィスTelegram: -1003889222847
  - topic 2: 報告チャンネル
  - topic 34: 会議レポート
- TK: @TK77777TK (id:944527519)
