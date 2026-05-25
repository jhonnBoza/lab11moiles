
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]
    @State private var mostrarFormulario = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(alumnos) { alumno in
                    NavigationLink {
                        VStack(alignment: .leading, spacing: 12) {
                            LabEncabezadoDetalle(simbolo: "person.fill", titulo: "Detalles del Alumno", color: .green)
                            Text("Nombre: \(alumno.nombre)")
                            Text("Apellido: \(alumno.apellido)")
                            Text("DNI: \(alumno.dni)")
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(alumno.apellido), \(alumno.nombre)")
                                .font(.headline)
                            Text("DNI: \(alumno.dni)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteAlumnos)
            }
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    LabTituloNavegacion(simbolo: "graduationcap.fill", titulo: "Alumnos", color: .green)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .green)
                    }
                    .accessibilityLabel("Nuevo Alumno")
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                NuevoAlumnoView()
            }
            .onAppear {
                AlumnoSeedData.seedIfNeeded()
            }
        }
    }

    private func deleteAlumnos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(alumnos[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ModeloContainerProvider.shared)
}
