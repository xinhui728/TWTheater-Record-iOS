import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section("資料") {
                LabeledContent(
                    "儲存方式",
                    value: "本機 SwiftData"
                )

                Text("私人觀劇紀錄採 local-first；目前不需要登入，也不會自動上傳完整私人紀錄。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("開發狀態") {
                Label(
                    "核心觀劇紀錄",
                    systemImage: "checkmark.circle"
                )

                Label(
                    "Taiwan Theater Calendar API：待串接",
                    systemImage: "clock"
                )

                Label(
                    "票根驗證：待串接",
                    systemImage: "clock"
                )

                Label(
                    "StoreKit／新增額度：待串接",
                    systemImage: "clock"
                )

                Label(
                    "通知／行事曆：待串接",
                    systemImage: "clock"
                )
            }

            Section("關於") {
                LabeledContent("App", value: "劇場日曆 iOS")
                LabeledContent("目前階段", value: "Pre-alpha")
            }

            Section {
                Text("目前程式先在 GitHub 建立，尚未經本機 Xcode、Simulator 或實體 iPhone 驗證。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("設定")
    }
}
