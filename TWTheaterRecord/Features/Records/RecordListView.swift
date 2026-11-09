import SwiftData
import SwiftUI

struct RecordListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TheaterRecord.updatedAt, order: .reverse)
    private var allRecords: [TheaterRecord]

    let mode: RecordListMode

    @State private var isPresentingAdd = false

    private var records: [TheaterRecord] {
        switch mode {
        case .records:
            allRecords.filter { $0.status == .watched }
        case .wishlist:
            allRecords.filter { $0.status == .wantToWatch }
        case .waiting:
            allRecords.filter { record in
                guard record.status == .watched,
                      record.performanceStatus != .cancelled,
                      let watchedDate = record.watchedDate
                else {
                    return false
                }

                return Calendar.current.compare(
                    watchedDate,
                    to: .now,
                    toGranularity: .day
                ) != .orderedAscending
            }
        }
    }

    var body: some View {
        Group {
            if records.isEmpty {
                ContentUnavailableView(
                    emptyTitle,
                    systemImage: emptySystemImage,
                    description: Text(emptyDescription)
                )
            } else {
                List {
                    ForEach(records) { record in
                        NavigationLink {
                            RecordDetailView(record: record)
                        } label: {
                            RecordRow(record: record)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(mode.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(addAccessibilityLabel)
            }
        }
        .sheet(isPresented: $isPresentingAdd) {
            NavigationStack {
                RecordFormView(
                    record: nil,
                    defaultStatus: mode.defaultStatus
                )
            }
        }
    }

    private var emptyTitle: String {
        switch mode {
        case .records:
            "還沒有觀劇紀錄"
        case .wishlist:
            "想看的劇先放這裡"
        case .waiting:
            "目前沒有待觀看演出"
        }
    }

    private var emptyDescription: String {
        switch mode {
        case .records:
            "按右上角＋新增第一筆觀劇紀錄。"
        case .wishlist:
            "看到想看的作品時，可以先加入想看清單。"
        case .waiting:
            "有未來場次的觀劇紀錄會自動出現在這裡。"
        }
    }

    private var emptySystemImage: String {
        switch mode {
        case .records:
            "theatermasks"
        case .wishlist:
            "bookmark"
        case .waiting:
            "clock"
        }
    }

    private var addAccessibilityLabel: String {
        mode == .wishlist ? "新增想看" : "新增觀劇紀錄"
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }

        try? modelContext.save()
    }
}

private struct RecordRow: View {
    let record: TheaterRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(record.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                if record.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("已收藏")
                }
            }

            if let date = record.watchedDate {
                HStack(spacing: 8) {
                    Label(
                        RecordFormatting.date.string(from: date),
                        systemImage: "calendar"
                    )

                    if let time = record.performanceTime {
                        Text(RecordFormatting.time.string(from: time))
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            if !record.venue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(record.venue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                Text(record.performanceStatus.label)

                if let rating = RecordFormatting.rating(record.rating) {
                    Text("★ \(rating)")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
