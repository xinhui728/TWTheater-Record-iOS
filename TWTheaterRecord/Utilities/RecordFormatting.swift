import Foundation

enum RecordFormatting {
    static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    static func money(_ value: Int?) -> String? {
        guard let value else { return nil }
        return currency.string(from: NSNumber(value: value))
    }

    static func rating(_ value: Double?) -> String? {
        guard let value else { return nil }
        return String(format: "%.1f / 5", value)
    }
}

extension TheaterRecord {
    func hasOccurred(now: Date = .now, calendar: Calendar = .current) -> Bool {
        guard status == .watched,
              performanceStatus != .cancelled,
              performanceStatus != .postponed,
              let watchedDate
        else {
            return false
        }

        let dayComparison = calendar.compare(
            watchedDate,
            to: now,
            toGranularity: .day
        )

        if dayComparison == .orderedAscending {
            return true
        }

        if dayComparison == .orderedDescending {
            return false
        }

        guard let performanceTime else {
            return false
        }

        let startOfToday = calendar.startOfDay(for: now)
        let components = calendar.dateComponents(
            [.hour, .minute],
            from: performanceTime
        )
        let performanceDateTime = calendar.date(
            byAdding: components,
            to: startOfToday
        )

        guard let performanceDateTime else {
            return false
        }

        return performanceDateTime <= now
    }
}
