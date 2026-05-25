//
//  ContentView.swift
//  Semana11SwiftUI
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]
    @State private var mostrarFormulario = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(alumnos) { alumno in
                    NavigationLink {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("👤 Detalles del Alumno")
                                .font(.title2.bold())
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
            .navigationTitle("📋 Alumnos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Selecciona un alumno")
                .foregroundStyle(.secondary)
        }
        .sheet(isPresented: $mostrarFormulario) {
            NuevoAlumnoView()
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
        .modelContainer(ModelContainerProvider.shared.container)
}
