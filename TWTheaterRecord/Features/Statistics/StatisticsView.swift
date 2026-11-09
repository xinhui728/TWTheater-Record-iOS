import Foundation
import SwiftData
import SwiftUI

struct StatisticsView: View {
    @Query(sort: \TheaterRecord.watchedDate, order: .reverse)
    private var allRecords: [TheaterRecord]

    @State private var selectedYear: Int?

    private var availableYears: [Int] {
        Array(
            Set(
                allRecords.compactMap { record in
                    guard record.hasOccurred(),
                          let date = record.watchedDate
                    else {
                        return nil
                    }

                    return Calendar.current.component(.year, from: date)
                }
            )
        )
        .sorted(by: >)
    }

    private var records: [TheaterRecord] {
        allRecords.filter { record in
            guard record.hasOccurred() else {
                return false
            }

            guard let selectedYear else {
                return true
            }

            guard let date = record.watchedDate else {
                return false
            }

            return Calendar.current.component(.year, from: date) == selectedYear
        }
    }

    private var totalSpent: Int {
        records.reduce(into: 0) { result, record in
            result += (record.paidAmount ?? record.ticketPrice ?? 0)
            result += record.otherExpenses ?? 0
        }
    }

    private var averageRating: Double? {
        let values = records.compactMap(\.rating)
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private var mostVisitedVenue: String? {
        let counts = records
            .map(\.venue)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .reduce(into: [String: Int]()) { result, venue in
                result[venue, default: 0] += 1
            }

        return counts.max { lhs, rhs in
            if lhs.value == rhs.value {
                return lhs.key > rhs.key
            }

            return lhs.value < rhs.value
        }?.key
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !availableYears.isEmpty {
                    Picker("年份", selection: $selectedYear) {
                        Text("全部").tag(Int?.none)

                        ForEach(availableYears, id: \.self) { year in
                            Text(String(year)).tag(Optional(year))
                        }
                    }
                    .pickerStyle(.menu)
                }

                if records.isEmpty {
                    ContentUnavailableView(
                        "還沒有可統計的紀錄",
                        systemImage: "chart.bar",
                        description: Text("已發生且有效的觀劇紀錄會出現在統計中。")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        spacing: 12
                    ) {
                        StatisticCard(
                            title: "觀劇場次",
                            value: "\(records.count)",
                            systemImage: "theatermasks"
                        )

                        StatisticCard(
                            title: "總花費",
                            value: RecordFormatting.money(totalSpent) ?? "—",
                            systemImage: "dollarsign.circle"
                        )

                        StatisticCard(
                            title: "平均評分",
                            value: averageRating.map {
                                String(format: "%.2f", $0)
                            } ?? "—",
                            systemImage: "star"
                        )

                        StatisticCard(
                            title: "最常去場館",
                            value: mostVisitedVenue ?? "—",
                            systemImage: "building.columns"
                        )
                    }

                    StatisticsRankingSection(
                        title: "常看分類",
                        values: rank(
                            records
                                .flatMap { splitLabels($0.category) }
                        )
                    )

                    StatisticsRankingSection(
                        title: "常看卡司",
                        values: rank(
                            records
                                .flatMap { splitLabels($0.cast) }
                        )
                    )
                }
            }
            .padding()
        }
        .navigationTitle("觀劇統計")
    }

    private func splitLabels(_ value: String) -> [String] {
        value
            .components(
                separatedBy: CharacterSet(
                    charactersIn: "、,，/／;；|\n"
                )
            )
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func rank(_ values: [String]) -> [(String, Int)] {
        let counts = values.reduce(into: [String: Int]()) { result, value in
            result[value, default: 0] += 1
        }

        return counts
            .map { ($0.key, $0.value) }
            .sorted {
                if $0.1 == $1.1 {
                    return $0.0 < $1.0
                }

                return $0.1 > $1.1
            }
            .prefix(5)
            .map { $0 }
    }
}

private struct StatisticCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3.bold())
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct StatisticsRankingSection: View {
    let title: String
    let values: [(String, Int)]

    var body: some View {
        if !values.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)

                ForEach(
                    Array(values.enumerated()),
                    id: \.offset
                ) { index, item in
                    HStack {
                        Text("\(index + 1)")
                            .foregroundStyle(.secondary)
                            .frame(width: 24, alignment: .leading)

                        Text(item.0)

                        Spacer()

                        Text("\(item.1) 次")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                }
            }
        }
    }
}
