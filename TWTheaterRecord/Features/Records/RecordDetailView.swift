import SwiftData
import SwiftUI

struct RecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let record: TheaterRecord

    @State private var isEditing = false
    @State private var isConfirmingDelete = false

    var body: some View {
        List {
            Section("演出資訊") {
                DetailRow(label: "狀態", value: record.status.label)
                DetailRow(label: "演出狀態", value: record.performanceStatus.label)

                if let watchedDate = record.watchedDate {
                    DetailRow(
                        label: "日期",
                        value: RecordFormatting.date.string(from: watchedDate)
                    )
                }

                if let performanceTime = record.performanceTime {
                    DetailRow(
                        label: "時間",
                        value: RecordFormatting.time.string(from: performanceTime)
                    )
                }

                DetailRow(label: "場館", value: record.venue)
                DetailRow(label: "卡司", value: record.cast)
                DetailRow(label: "分類", value: record.category)
                DetailRow(label: "劇目", value: record.production)
            }

            Section("我的觀劇紀錄") {
                DetailRow(label: "座位", value: record.seat)

                if let value = RecordFormatting.money(record.ticketPrice) {
                    DetailRow(label: "票面價格", value: value)
                }

                if let value = RecordFormatting.money(record.paidAmount) {
                    DetailRow(label: "實付", value: value)
                }

                if let value = RecordFormatting.money(record.otherExpenses) {
                    DetailRow(label: "其他花費", value: value)
                }

                if let value = RecordFormatting.rating(record.rating) {
                    DetailRow(label: "評分", value: value)
                }
            }

            if !record.review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Section("心得") {
                    Text(record.review)
                }
            }

            if !record.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Section("備註") {
                    Text(record.note)
                }
            }

            Section {
                Button("刪除紀錄", role: .destructive) {
                    isConfirmingDelete = true
                }
            }
        }
        .navigationTitle(record.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("編輯") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                RecordFormView(
                    record: record,
                    defaultStatus: record.status
                )
            }
        }
        .confirmationDialog(
            "確定刪除「\(record.title)」？",
            isPresented: $isConfirmingDelete,
            titleVisibility: .visible
        ) {
            Button("刪除", role: .destructive) {
                modelContext.delete(record)
                try? modelContext.save()
                dismiss()
            }

            Button("取消", role: .cancel) {}
        }
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    var body: some View {
        if !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            LabeledContent(label, value: value)
        }
    }
}
