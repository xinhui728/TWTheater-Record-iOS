import SwiftData
import SwiftUI

struct RecordFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    private let record: TheaterRecord?
    private let defaultStatus: RecordStatus

    @State private var status: RecordStatus
    @State private var title: String
    @State private var hasWatchedDate: Bool
    @State private var watchedDate: Date
    @State private var hasPerformanceTime: Bool
    @State private var performanceTime: Date
    @State private var performanceStatus: PerformanceStatus
    @State private var venue: String
    @State private var cast: String
    @State private var category: String
    @State private var production: String
    @State private var seat: String
    @State private var ticketPrice: String
    @State private var paidAmount: String
    @State private var otherExpenses: String
    @State private var hasRating: Bool
    @State private var rating: Double
    @State private var review: String
    @State private var note: String
    @State private var isFavorite: Bool

    @State private var errorMessage: String?

    init(
        record: TheaterRecord?,
        defaultStatus: RecordStatus
    ) {
        self.record = record
        self.defaultStatus = defaultStatus

        let initialStatus = record?.status ?? defaultStatus

        _status = State(initialValue: initialStatus)
        _title = State(initialValue: record?.title ?? "")
        _hasWatchedDate = State(
            initialValue: record?.watchedDate != nil || initialStatus == .watched
        )
        _watchedDate = State(initialValue: record?.watchedDate ?? .now)
        _hasPerformanceTime = State(initialValue: record?.performanceTime != nil)
        _performanceTime = State(initialValue: record?.performanceTime ?? .now)
        _performanceStatus = State(initialValue: record?.performanceStatus ?? .normal)
        _venue = State(initialValue: record?.venue ?? "")
        _cast = State(initialValue: record?.cast ?? "")
        _category = State(initialValue: record?.category ?? "")
        _production = State(initialValue: record?.production ?? "")
        _seat = State(initialValue: record?.seat ?? "")
        _ticketPrice = State(initialValue: record?.ticketPrice.map(String.init) ?? "")
        _paidAmount = State(initialValue: record?.paidAmount.map(String.init) ?? "")
        _otherExpenses = State(initialValue: record?.otherExpenses.map(String.init) ?? "")
        _hasRating = State(initialValue: record?.rating != nil)
        _rating = State(initialValue: record?.rating ?? 3)
        _review = State(initialValue: record?.review ?? "")
        _note = State(initialValue: record?.note ?? "")
        _isFavorite = State(initialValue: record?.isFavorite ?? false)
    }

    var body: some View {
        Form {
            Section {
                Picker("紀錄類型", selection: $status) {
                    ForEach(RecordStatus.allCases) { value in
                        Text(value.label).tag(value)
                    }
                }
                .pickerStyle(.segmented)

                Toggle("收藏", isOn: $isFavorite)
            }

            Section("演出資訊") {
                TextField("劇名＊", text: $title)

                Toggle("有演出日期", isOn: $hasWatchedDate)
                    .disabled(status == .watched)

                if hasWatchedDate {
                    DatePicker(
                        "日期",
                        selection: $watchedDate,
                        displayedComponents: .date
                    )
                }

                Toggle("有演出時間", isOn: $hasPerformanceTime)

                if hasPerformanceTime {
                    DatePicker(
                        "時間",
                        selection: $performanceTime,
                        displayedComponents: .hourAndMinute
                    )
                }

                Picker("演出狀態", selection: $performanceStatus) {
                    ForEach(PerformanceStatus.allCases) { value in
                        Text(value.label).tag(value)
                    }
                }

                TextField("場館", text: $venue)
                TextField("卡司", text: $cast, axis: .vertical)
                    .lineLimit(1...4)
                TextField("分類", text: $category)
                TextField("劇目／系列", text: $production)
            }

            Section("我的觀劇紀錄") {
                TextField("座位", text: $seat)
                NumberField(title: "票面價格", text: $ticketPrice)
                NumberField(title: "實付", text: $paidAmount)
                NumberField(title: "其他花費", text: $otherExpenses)
            }

            Section("評分") {
                Toggle("加入評分", isOn: $hasRating)

                if hasRating {
                    HStack {
                        Slider(
                            value: $rating,
                            in: 1...5,
                            step: 0.5
                        )

                        Text(String(format: "%.1f", rating))
                            .monospacedDigit()
                            .frame(width: 36)
                    }
                }
            }

            Section("心得") {
                TextField(
                    "寫下觀劇心得",
                    text: $review,
                    axis: .vertical
                )
                .lineLimit(4...10)
            }

            Section("備註") {
                TextField(
                    "私人備註",
                    text: $note,
                    axis: .vertical
                )
                .lineLimit(2...6)
            }
        }
        .navigationTitle(record == nil ? createTitle : "編輯紀錄")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("儲存") {
                    save()
                }
            }
        }
        .alert(
            "無法儲存",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("好", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .onChange(of: status) { _, newValue in
            if newValue == .watched {
                hasWatchedDate = true
            }
        }
    }

    private var createTitle: String {
        defaultStatus == .wantToWatch ? "新增想看" : "新增觀劇紀錄"
    }

    private func save() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedTitle.isEmpty else {
            errorMessage = "請輸入劇名。"
            return
        }

        guard status != .watched || hasWatchedDate else {
            errorMessage = "觀劇紀錄需要演出日期。"
            return
        }

        guard let parsedTicketPrice = parseMoney(ticketPrice, fieldName: "票面價格"),
              let parsedPaidAmount = parseMoney(paidAmount, fieldName: "實付"),
              let parsedOtherExpenses = parseMoney(otherExpenses, fieldName: "其他花費")
        else {
            return
        }

        let date = hasWatchedDate ? watchedDate : nil
        let time = hasPerformanceTime ? performanceTime : nil
        let savedRating = hasRating ? rating : nil

        if let record {
            let dateChanged = !sameCalendarDay(record.watchedDate, date)
            let timeChanged = !sameClockTime(record.performanceTime, time)

            record.title = cleanedTitle
            record.status = status
            record.watchedDate = date
            record.performanceTime = time
            record.performanceStatus = performanceStatus
            record.venue = venue
            record.cast = cast
            record.category = category
            record.production = production
            record.seat = seat
            record.ticketPrice = parsedTicketPrice
            record.paidAmount = parsedPaidAmount
            record.otherExpenses = parsedOtherExpenses
            record.rating = savedRating
            record.review = review
            record.note = note
            record.isFavorite = isFavorite
            record.updatedAt = .now

            if dateChanged || timeChanged {
                record.catalogPerformanceID = nil
            }
        } else {
            modelContext.insert(
                TheaterRecord(
                    title: cleanedTitle,
                    status: status,
                    watchedDate: date,
                    performanceTime: time,
                    performanceStatus: performanceStatus,
                    venue: venue,
                    cast: cast,
                    category: category,
                    production: production,
                    seat: seat,
                    ticketPrice: parsedTicketPrice,
                    paidAmount: parsedPaidAmount,
                    otherExpenses: parsedOtherExpenses,
                    rating: savedRating,
                    review: review,
                    note: note,
                    isFavorite: isFavorite
                )
            )
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "資料儲存失敗：\(error.localizedDescription)"
        }
    }

    private func parseMoney(
        _ text: String,
        fieldName: String
    ) -> Int?? {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleaned.isEmpty {
            return .some(nil)
        }

        guard let value = Int(cleaned), value >= 0 else {
            errorMessage = "\(fieldName)必須是 0 以上的整數。"
            return nil
        }

        return .some(value)
    }

    private func sameCalendarDay(
        _ lhs: Date?,
        _ rhs: Date?
    ) -> Bool {
        switch (lhs, rhs) {
        case (nil, nil):
            true
        case let (lhs?, rhs?):
            Calendar.current.isDate(lhs, inSameDayAs: rhs)
        default:
            false
        }
    }

    private func sameClockTime(
        _ lhs: Date?,
        _ rhs: Date?
    ) -> Bool {
        switch (lhs, rhs) {
        case (nil, nil):
            true
        case let (lhs?, rhs?):
            let calendar = Calendar.current
            let left = calendar.dateComponents([.hour, .minute], from: lhs)
            let right = calendar.dateComponents([.hour, .minute], from: rhs)
            return left.hour == right.hour && left.minute == right.minute
        default:
            false
        }
    }
}

private struct NumberField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        TextField(title, text: $text)
            .keyboardType(.numberPad)
    }
}
