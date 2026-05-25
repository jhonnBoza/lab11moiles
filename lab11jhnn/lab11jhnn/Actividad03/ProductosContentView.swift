import SwiftUI
import SwiftData

struct ProductosContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var formularioModo: ProductoFormularioModo?

    var body: some View {
        List {
            ForEach(productos) { producto in
                NavigationLink {
                    detalle(producto)
                } label: {
                    filaProducto(producto)
                }
                .contextMenu {
                    Button {
                        formularioModo = .editar(producto)
                    } label: {
                        Label("Editar", systemImage: "pencil")
                    }
                }
            }
            .onDelete(perform: deleteProductos)
        }
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                LabTituloNavegacion(simbolo: "shippingbox.fill", titulo: "Productos", color: .orange)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    formularioModo = .nuevo
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .orange)
                }
                .accessibilityLabel("Nuevo producto")
            }
        }
        .sheet(item: $formularioModo) { modo in
            NuevoProductoView(modo: modo)
        }
    }

    @ViewBuilder
    private func filaProducto(_ producto: Producto) -> some View {
        HStack(spacing: 12) {
            if let data = producto.imagenData, let img = UIImage(data: data) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "shippingbox.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                }
            }
            VStack(alignment: .leading) {
                Text(producto.nombre).font(.headline)
                Text("S/ \(producto.precio, specifier: "%.2f") · Stock: \(producto.stock)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(producto.categoria).font(.caption).foregroundStyle(.tertiary)
            }
        }
    }

    @ViewBuilder
    private func detalle(_ producto: Producto) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            LabEncabezadoDetalle(simbolo: "cart.fill", titulo: "Detalle del Producto", color: .orange)
            if let data = producto.imagenData, let img = UIImage(data: data) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.12))
                        .frame(height: 140)
                    Image(systemName: "shippingbox.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(.orange)
                }
            }
            Text("ID: \(producto.idProducto.uuidString)")
            Text("Nombre: \(producto.nombre)")
            Text("Precio: S/ \(producto.precio, specifier: "%.2f")")
            Text("Stock: \(producto.stock)")
            Text("Categoría: \(producto.categoria)")
            Button("Editar") {
                formularioModo = .editar(producto)
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
