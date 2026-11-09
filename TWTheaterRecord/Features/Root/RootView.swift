import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                RecordListView(mode: .records)
            }
            .tabItem {
                Label("紀錄", systemImage: "theatermasks")
            }

            NavigationStack {
                RecordListView(mode: .wishlist)
            }
            .tabItem {
                Label("想看", systemImage: "bookmark")
            }

            NavigationStack {
                RecordListView(mode: .waiting)
            }
            .tabItem {
                Label("待觀看", systemImage: "clock")
            }

            NavigationStack {
                StatisticsView()
            }
            .tabItem {
                Label("統計", systemImage: "chart.bar")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("設定", systemImage: "gearshape")
            }
        }
    }
}
