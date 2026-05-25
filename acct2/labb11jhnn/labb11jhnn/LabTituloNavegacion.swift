
import SwiftUI

struct LabTituloNavegacion: View {
    let simbolo: String
    let titulo: String
    var color: Color = .accentColor

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: simbolo)
                .font(.title3.weight(.semibold))
                .foregroundStyle(color)
            Text(titulo)
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}

struct LabEncabezadoDetalle: View {
    let simbolo: String
    let titulo: String
    var color: Color = .accentColor

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: simbolo)
                .font(.title)
                .foregroundStyle(color)
            Text(titulo)
                .font(.title2.bold())
        }
    }
}
