# TWTheater Record iOS

「劇場日曆」觀劇紀錄 App 的 iOS / SwiftUI 版本。

目前先在 GitHub 建立可由 Xcode 開啟的原生 iOS 專案。因開發端尚未有 Mac，本機 Xcode、Simulator、實體 iPhone 與 signing 尚未人工驗證；GitHub Actions 會先用 macOS runner 做無簽章的 Simulator build。

## 技術

- Swift
- SwiftUI
- SwiftData
- iOS 17+
- Local-first 私人觀劇紀錄
- GitHub Actions / \`xcodebuild\`

## 目前已完成

- Xcode project / shared scheme
- 觀劇紀錄、想看清單、待觀看
- 新增／編輯／刪除紀錄
- 劇名、日期、時間、場館、卡司、分類、劇目
- 座位、票面價格、實付、其他花費
- 1～5 分、每 0.5 分一階的私人評分
- 心得、備註、收藏
- 基本年度／全部統計
- SwiftData 本機持久化
- 修改日期／時間時清除舊的精確 performance ID
- GitHub Actions Simulator build

## 尚未實作

- Taiwan Theater Calendar 搜尋與精確場次選擇
- 售票網址解析
- 票根驗證／重新上傳
- 自訂其他花費分類
- 紀錄衝突提醒
- Rewarded Ads / StoreKit 額度
- 帳號與 server-authoritative quota
- 本機通知、EventKit 行事曆
- 備份／還原
- 近期演出、人物關注
- 完整 unit / UI tests

詳見 [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。

## 有 Mac 後的第一次執行

1. \`git clone https://github.com/xinhui728/TWTheater-Record-iOS.git\`
2. 用 Xcode 開啟 \`TWTheaterRecord.xcodeproj\`
3. 選擇 \`TWTheaterRecord\` target
4. 在 **Signing & Capabilities** 選自己的 Apple Development Team
5. 先選 iPhone Simulator 執行
6. 再接 iPhone 做實機測試

如果 Xcode 自動更新 project format 或 signing 設定，請把非個人化的 project 變更提交回 GitHub；不要提交憑證、provisioning profile 或私人 signing secret。
