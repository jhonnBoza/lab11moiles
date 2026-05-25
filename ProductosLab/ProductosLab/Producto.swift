import Foundation
import SwiftData

@Model
class Producto {
    var idProducto: UUID
    var nombre: String
    var precio: Double
    var stock: Int
    var categoria: String
    @Attribute(.externalStorage) var imagenData: Data?

    init(
        idProducto: UUID = UUID(),
        nombre: String,
        precio: Double,
        stock: Int,
        categoria: String,
        imagenData: Data? = nil
    ) {
        self.idProducto = idProducto
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
        self.categoria = categoria
        self.imagenData = imagenData
    }
}
