//
//  LabSeedData.swift
//  lab11jhnn — Datos de demostración del GLAB-S11
//

import UIKit
import CoreData
import SwiftData

enum LabSeedData {

    @MainActor
    static func seedAllIfNeeded() {
        seedContactosIfNeeded()
        seedAlumnosIfNeeded()
        seedProductosIfNeeded()
    }

    // MARK: - Actividad 01 (Core Data)

    static func seedContactosIfNeeded() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let solicitud = NSFetchRequest<Contacto>(entityName: "Contacto")

        guard (try? context.count(for: solicitud)) == 0 else { return }

        let muestras: [(String, String, String)] = [
            ("Juan León", "986464533", "Las Begonias"),
            ("Jaime Gómez", "987654321", "Miraflores"),
            ("Jaime Farfán", "965432187", "San Isidro"),
            ("Silvia Montoya", "912345678", "Surco"),
            ("Carlos Rojas", "998877665", "La Molina"),
            ("Ana Torres", "976543210", "San Borja"),
            ("Luis Mendoza", "945612378", "Los Olivos"),
            ("María Vargas", "934567890", "Comas"),
            ("Pedro Sánchez", "923456781", "Callao"),
            ("Rosa Díaz", "911223344", "Chorrillos")
        ]

        for (nombre, telefono, direccion) in muestras {
            let contacto = Contacto(context: context)
            contacto.nombre = nombre
            contacto.telefono = telefono
            contacto.direccion = direccion
        }

        try? context.save()
    }

    // MARK: - Actividad 02 (SwiftData)

    @MainActor
    static func seedAlumnosIfNeeded() {
        let context = ModelContext(ModelContainerProvider.shared)
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

    // MARK: - Actividad 03 (SwiftData)

    @MainActor
    static func seedProductosIfNeeded() {
        let context = ModelContext(ProductoContainerProvider.shared)
        guard (try? context.fetchCount(FetchDescriptor<Producto>())) == 0 else { return }

        let muestras: [(String, Double, Int, String)] = [
            ("Laptop Dell Inspiron", 2499.99, 8, "Electrónica"),
            ("Mouse Logitech M185", 49.90, 45, "Accesorios"),
            ("Teclado mecánico RGB", 189.00, 22, "Accesorios"),
            ("Monitor LG 24\"", 599.50, 15, "Electrónica"),
            ("SSD Kingston 1TB", 320.00, 30, "Almacenamiento"),
            ("Webcam HD 1080p", 129.99, 18, "Periféricos"),
            ("Audífonos Bluetooth", 159.00, 25, "Audio"),
            ("Hub USB-C 7 en 1", 89.90, 40, "Accesorios")
        ]

        for (nombre, precio, stock, categoria) in muestras {
            context.insert(Producto(
                nombre: nombre,
                precio: precio,
                stock: stock,
                categoria: categoria
            ))
        }

        try? context.save()
    }
}
