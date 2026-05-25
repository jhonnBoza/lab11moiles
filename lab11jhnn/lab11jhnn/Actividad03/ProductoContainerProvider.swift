import Foundation
import SwiftData

@MainActor
enum ProductoContainerProvider {
    static let shared: ModelContainer = {
        let schema = Schema([Producto.self])
        do {
            let support = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!
            let storeURL = support.appendingPathComponent("ProductosData.sqlite")
            let config = ModelConfiguration("ProductosData", url: storeURL)
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar Productos: \(error)")
        }
    }()
}
