import SwiftUI
import SwiftData
import PhotosUI

struct NuevoProductoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var productoEditar: Producto?

    @State private var nombre = ""
    @State private var precioTexto = ""
    @State private var stockTexto = ""
    @State private var categoria = ""
    @State private var fotoItem: PhotosPickerItem?
    @State private var imagenData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del Producto")) {
                    TextField("Nombre", text: $nombre)
                    TextField("Precio", text: $precioTexto)
                        .keyboardType(.decimalPad)
                    TextField("Stock", text: $stockTexto)
                        .keyboardType(.numberPad)
                    TextField("Categoría", text: $categoria)
                }

                Section(header: Text("Imagen (opcional)")) {
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

                Button(productoEditar == nil ? "Guardar Producto" : "Actualizar Producto") {
                    guard let precio = Double(precioTexto),
                          let stock = Int(stockTexto) else { return }

                    if let productoEditar {
                        productoEditar.nombre = nombre
                        productoEditar.precio = precio
                        productoEditar.stock = stock
                        productoEditar.categoria = categoria
                        productoEditar.imagenData = imagenData
                    } else {
                        let nuevo = Producto(
                            nombre: nombre,
                            precio: precio,
                            stock: stock,
                            categoria: categoria,
                            imagenData: imagenData
                        )
                        modelContext.insert(nuevo)
                    }

                    do { try modelContext.save() } catch {
                        print("Error al guardar producto: \(error)")
                    }
                    dismiss()
                }
                .disabled(nombre.isEmpty || categoria.isEmpty || Double(precioTexto) == nil || Int(stockTexto) == nil)
            }
            .navigationTitle(productoEditar == nil ? "Nuevo Producto" : "Editar Producto")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onAppear(perform: cargarDatos)
            .onChange(of: fotoItem) { _, nuevo in
                Task {
                    if let data = try? await nuevo?.loadTransferable(type: Data.self) {
                        imagenData = data
                    }
                }
            }
        }
    }

    private func cargarDatos() {
        guard let productoEditar else { return }
        nombre = productoEditar.nombre
        precioTexto = String(productoEditar.precio)
        stockTexto = String(productoEditar.stock)
        categoria = productoEditar.categoria
        imagenData = productoEditar.imagenData
    }
}
