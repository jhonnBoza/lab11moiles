import SwiftData

enum AlumnoSeedData {
    @MainActor
    static func seedIfNeeded() {
        let context = ModelContext(ModeloContainerProvider.shared)
        guard (try? context.fetchCount(FetchDescriptor<Alumno>())) == 0 else { return }

        let muestras: [(String, String, String)] = [
            ("Farfan", "Jaime", "29282827"),
            ("Gomez", "Jaime", "09393834"),
            ("León Suiyon", "Juan José", "0939393"),
            ("Montoya", "Silvia", "09292828"),
            ("Pérez", "Lucía", "08456712"),
            ("Quispe", "Miguel", "07543210")
        ]

        for (apellido, nombre, dni) in muestras {
            context.insert(Alumno(apellido: apellido, nombre: nombre, dni: dni))
        }
        try? context.save()
    }
}
