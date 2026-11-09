import Foundation
import SwiftData

@Model
final class TheaterRecord {
    @Attribute(.unique) var id: UUID

    var title: String
    var statusRawValue: String
    var watchedDate: Date?
    var performanceTime: Date?
    var performanceStatusRawValue: String

    var venue: String
    var cast: String
    var category: String
    var production: String

    var seat: String
    var ticketPrice: Int?
    var paidAmount: Int?
    var otherExpenses: Int?

    var rating: Double?
    var review: String
    var note: String
    var isFavorite: Bool

    var sourcePlatform: String
    var sourceURL: String
    var sourceExternalID: String
    var catalogProductionID: Int?
    var catalogPerformanceID: Int?

    var reminderEnabled: Bool
    var reminderTime: Date?

    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        status: RecordStatus,
        watchedDate: Date? = nil,
        performanceTime: Date? = nil,
        performanceStatus: PerformanceStatus = .normal,
        venue: String = "",
        cast: String = "",
        category: String = "",
        production: String = "",
        seat: String = "",
        ticketPrice: Int? = nil,
        paidAmount: Int? = nil,
        otherExpenses: Int? = nil,
        rating: Double? = nil,
        review: String = "",
        note: String = "",
        isFavorite: Bool = false,
        sourcePlatform: String = "",
        sourceURL: String = "",
        sourceExternalID: String = "",
        catalogProductionID: Int? = nil,
        catalogPerformanceID: Int? = nil,
        reminderEnabled: Bool = false,
        reminderTime: Date? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.statusRawValue = status.rawValue
        self.watchedDate = watchedDate
        self.performanceTime = performanceTime
        self.performanceStatusRawValue = performanceStatus.rawValue
        self.venue = venue
        self.cast = cast
        self.category = category
        self.production = production
        self.seat = seat
        self.ticketPrice = ticketPrice
        self.paidAmount = paidAmount
        self.otherExpenses = otherExpenses
        self.rating = rating
        self.review = review
        self.note = note
        self.isFavorite = isFavorite
        self.sourcePlatform = sourcePlatform
        self.sourceURL = sourceURL
        self.sourceExternalID = sourceExternalID
        self.catalogProductionID = catalogProductionID
        self.catalogPerformanceID = catalogPerformanceID
        self.reminderEnabled = reminderEnabled
        self.reminderTime = reminderTime
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var status: RecordStatus {
        get { RecordStatus(rawValue: statusRawValue) ?? .watched }
        set { statusRawValue = newValue.rawValue }
    }

    var performanceStatus: PerformanceStatus {
        get { PerformanceStatus(rawValue: performanceStatusRawValue) ?? .normal }
        set { performanceStatusRawValue = newValue.rawValue }
    }
}
