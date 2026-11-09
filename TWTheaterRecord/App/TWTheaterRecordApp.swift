import SwiftData
import SwiftUI

@main
struct TWTheaterRecordApp: App {
    private let modelContainer: ModelContainer = {
        let schema = Schema([
            TheaterRecord.self,
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Unable to create SwiftData container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(modelContainer)
    }
}
