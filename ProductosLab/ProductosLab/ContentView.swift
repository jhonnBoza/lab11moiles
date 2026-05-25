import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var mostrarFormulario = false
    @State private var productoAEditar: Producto?

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(productos) { producto in
                    NavigationLink {
                        detalleProducto(producto)
                    } label: {
                        filaProducto(producto)
                    }
                }
                .onDelete(perform: deleteProductos)
            }
            .navigationTitle("📦 Productos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        productoAEditar = nil
                        mostrarFormulario = true
                    } label: {
                        Label("Nuevo", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Selecciona un producto")
                .foregroundStyle(.secondary)
        }
        .sheet(isPresented: $mostrarFormulario) {
            NuevoProductoView(productoEditar: productoAEditar)
        }
    }

    @ViewBuilder
    private func filaProducto(_ producto: Producto) -> some View {
        HStack(spacing: 12) {
            if let data = producto.imagenData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "shippingbox")
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.secondary)
            }
            VStack(alignment: .leading) {
                Text(producto.nombre)
                    .font(.headline)
                Text("S/ \(producto.precio, specifier: "%.2f") · Stock: \(producto.stock)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(producto.categoria)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    @ViewBuilder
    private func detalleProducto(_ producto: Producto) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Detalle del Producto")
                .font(.title2.bold())
            if let data = producto.imagenData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            Text("ID: \(producto.idProducto.uuidString)")
            Text("Nombre: \(producto.nombre)")
            Text("Precio: S/ \(producto.precio, specifier: "%.2f")")
            Text("Stock: \(producto.stock)")
            Text("Categoría: \(producto.categoria)")
            Button("Editar") {
                productoAEditar = producto
                mostrarFormulario = true
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func deleteProductos(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(productos[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ProductoContainerProvider.shared.container)
}
