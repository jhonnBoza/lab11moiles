//
//  ModeloContainerProvider.swift
//  Semana11SwiftUI
//

import Foundation
import SwiftData

@MainActor
class ModelContainerProvider {
    static let shared = ModelContainerProvider()

    let container: ModelContainer

    private init() {
        let schema = Schema([Alumno.self])
        do {
            let supportURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let storeURL = supportURL.appendingPathComponent("AlumnosData.sqlite")
            let config = ModelConfiguration("AlumnosData", url: storeURL)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
