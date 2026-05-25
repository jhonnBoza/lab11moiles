
import Foundation
import SwiftData

@MainActor
enum ModeloContainerProvider {
    static let shared: ModelContainer = {
        let schema = Schema([Alumno.self])
        do {
            let support = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let storeURL = support.appendingPathComponent("AlumnosData.sqlite")
            let config = ModelConfiguration("AlumnosData", url: storeURL)
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }()
}
