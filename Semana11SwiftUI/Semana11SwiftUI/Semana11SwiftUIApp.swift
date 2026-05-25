//
//  Semana11SwiftUIApp.swift
//  Semana11SwiftUI
//

import SwiftUI
import SwiftData

@main
struct Semana11SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ModelContainerProvider.shared.container)
    }
}
