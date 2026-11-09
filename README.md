# TWTheater Record iOS

劇場日曆的 iOS / SwiftUI 版本。

> 此專案目前先在 GitHub 建立與維護，尚未經本機 Xcode、iPhone Simulator 或實體 iPhone 驗證。GitHub Actions 會負責可自動化的編譯檢查；取得 Mac 後再完成 Xcode signing、Simulator 與實機測試。

## 目標

- Swift + SwiftUI
- Local-first 私人觀劇紀錄
- SwiftData 本機儲存
- 與 Android 版對齊核心資料語意
- 後續串接 Taiwan Theater Calendar API
- 後續支援票根驗證、StoreKit、通知與備份

## 第一階段

- 觀劇紀錄
- 想看清單
- 待觀看
- 新增／編輯／刪除紀錄
- 票價、實付、其他花費
- 0.5 星評分
- 基本年度統計
- 本機 SwiftData 儲存

## 開發狀態

目前尚未經實體 Mac / Xcode 驗證。取得 Mac 後：

1. Clone repository。
2. 用 Xcode 開啟 `TWTheaterRecord.xcodeproj`。
3. 在 Signing & Capabilities 選擇自己的 Apple Development Team。
4. 先以 iPhone Simulator 執行。
5. 再接 iPhone 做實機測試。
