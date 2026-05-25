import SwiftUI
import SwiftData
import PhotosUI

enum ProductoFormularioModo: Identifiable {
    case nuevo
    case editar(Producto)

    var id: String {
        switch self {
        case .nuevo:
            return "nuevo"
        case .editar(let producto):
            return producto.idProducto.uuidString
        }
    }

    var producto: Producto? {
        if case .editar(let p) = self { return p }
        return nil
    }
}

struct NuevoProductoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let modo: ProductoFormularioModo

    @State private var nombre: String
    @State private var precioTexto: String
    @State private var stockTexto: String
    @State private var categoria: String
    @State private var fotoItem: PhotosPickerItem?
    @State private var imagenData: Data?

    private var productoEditar: Producto? { modo.producto }
    private var esEdicion: Bool { productoEditar != nil }

    init(modo: ProductoFormularioModo) {
        self.modo = modo
        let producto = modo.producto
        _nombre = State(initialValue: producto?.nombre ?? "")
        _precioTexto = State(initialValue: producto.map { Self.textoPrecio($0.precio) } ?? "")
        _stockTexto = State(initialValue: producto.map { String($0.stock) } ?? "")
        _categoria = State(initialValue: producto?.categoria ?? "")
        _imagenData = State(initialValue: producto?.imagenData)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del Producto") {
                    TextField("Nombre", text: $nombre)
                    TextField("Precio", text: $precioTexto)
                        .keyboardType(.decimalPad)
                    TextField("Stock", text: $stockTexto)
                        .keyboardType(.numberPad)
                    TextField("Categoría", text: $categoria)
                }
                Section("Imagen (opcional)") {
                    PhotosPicker(selection: $fotoItem, matching: .images) {
                        Label("Seleccionar imagen", systemImage: "photo")
                    }
                    if let imagenData, let uiImage = UIImage(data: imagenData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 160)
                    }
                }
                Button(esEdicion ? "Actualizar Producto" : "Guardar Producto") {
                    guard let precio = Self.precioDesdeTexto(precioTexto),
                          let stock = Int(stockTexto.trimmingCharacters(in: .whitespaces)) else { return }

                    if let productoEditar {
                        productoEditar.nombre = nombre.trimmingCharacters(in: .whitespaces)
                        productoEditar.precio = precio
                        productoEditar.stock = stock
                        productoEditar.categoria = categoria.trimmingCharacters(in: .whitespaces)
                        productoEditar.imagenData = imagenData
                    } else {
                        modelContext.insert(Producto(
                            nombre: nombre.trimmingCharacters(in: .whitespaces),
                            precio: precio,
                            stock: stock,
                            categoria: categoria.trimmingCharacters(in: .whitespaces),
                            imagenData: imagenData
                        ))
                    }

                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        print("Error al guardar producto: \(error)")
                    }
                }
                .disabled(!formularioValido)
            }
            .navigationTitle(esEdicion ? "Editar Producto" : "Nuevo Producto")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onChange(of: fotoItem) { _, nuevo in
                Task {
                    if let data = try? await nuevo?.loadTransferable(type: Data.self) {
                        imagenData = data
                    }
                }
            }
        }
    }

    private var formularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty
            && !categoria.trimmingCharacters(in: .whitespaces).isEmpty
            && Self.precioDesdeTexto(precioTexto) != nil
            && Int(stockTexto.trimmingCharacters(in: .whitespaces)) != nil
    }

    private static func textoPrecio(_ valor: Double) -> String {
        String(format: "%.2f", valor)
    }

    private static func precioDesdeTexto(_ texto: String) -> Double? {
        let limpio = texto.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")
        return Double(limpio)
    }
}
