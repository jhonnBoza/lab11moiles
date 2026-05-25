import Foundation
import SwiftData

@MainActor
class ProductoContainerProvider {
    static let shared = ProductoContainerProvider()

    let container: ModelContainer

    private init() {
        let schema = Schema([Producto.self])
        do {
            let appSupport = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!
            let storeURL = appSupport.appendingPathComponent("ProductosData.sqlite")
            let config = ModelConfiguration("ProductosData", url: storeURL)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer de productos: \(error)")
        }
    }
}
