
import SwiftUI
import SwiftData

@main
struct labb11jhnnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ModeloContainerProvider.shared)
    }
}
