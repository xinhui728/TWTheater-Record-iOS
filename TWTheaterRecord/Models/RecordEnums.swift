import Foundation

enum RecordStatus: String, CaseIterable, Identifiable {
    case watched = "WATCHED"
    case wantToWatch = "WANT_TO_WATCH"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .watched:
            "觀劇"
        case .wantToWatch:
            "想看"
        }
    }
}

enum PerformanceStatus: String, CaseIterable, Identifiable {
    case normal = "NORMAL"
    case postponed = "POSTPONED"
    case rescheduled = "RESCHEDULED"
    case cancelled = "CANCELLED"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .normal:
            "正常"
        case .postponed:
            "延期"
        case .rescheduled:
            "改期"
        case .cancelled:
            "取消"
        }
    }
}

enum RecordListMode {
    case records
    case wishlist
    case waiting

    var title: String {
        switch self {
        case .records:
            "觀劇紀錄"
        case .wishlist:
            "想看清單"
        case .waiting:
            "待觀看"
        }
    }

    var defaultStatus: RecordStatus {
        switch self {
        case .wishlist:
            .wantToWatch
        case .records, .waiting:
            .watched
        }
    }
}
