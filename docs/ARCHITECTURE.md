# iOS App 架構

## 原則

iOS 版先維持與 Android 版一致的產品邊界：

- 私人觀劇紀錄 local-first。
- UI 不直接負責遠端 API 邏輯。
- 精確 Taiwan Theater Calendar performance ID 不可由日期／時間猜測。
- 使用者手動修改日期或時間後，原精確 performance ID 必須清除。
- 票根、座位、票價、私人心得與其他花費不因一般同步流程自動公開。

## 第一階段資料流

\`\`\`text
SwiftUI View
    ↓
SwiftData ModelContext / Query
    ↓
TheaterRecord
\`\`\`

目前先完成可以獨立離線使用的核心資料層。後續網路功能加入後會演進成：

\`\`\`text
SwiftUI
   ↓
Feature / ViewModel
   ↓
Repository / Service
   ├── SwiftData
   ├── Taiwan Theater Calendar API
   ├── Verification API
   ├── StoreKit
   └── Notification / Calendar integrations
\`\`\`

## 目錄

\`\`\`text
TWTheaterRecord/
├── App/
├── Models/
├── Features/
│   ├── Root/
│   ├── Records/
│   ├── Statistics/
│   └── Settings/
└── Utilities/
\`\`\`

## Android 對照

| Android | iOS |
| --- | --- |
| Kotlin | Swift |
| Jetpack Compose | SwiftUI |
| Room | SwiftData |
| ViewModel / UiState | Observable state / feature model |
| Retrofit / API client | URLSession / API client |
| Google Play Billing | StoreKit 2 |
| Android notifications | UserNotifications |
| Calendar ACTION_INSERT | EventKit |

## 尚未實作

- Taiwan Theater Calendar 搜尋與精確場次選擇
- 售票網址解析
- 票根驗證投稿／重新上傳
- 自訂其他花費分類
- 紀錄衝突提醒
- Rewarded Ads / StoreKit 額度
- 帳號與 server-authoritative quota
- 本機通知
- EventKit 行事曆
- 備份／還原
- 近期演出與人物關注
- UI / unit tests

這些功能會在核心專案先通過 Xcode build 後逐步加入。
