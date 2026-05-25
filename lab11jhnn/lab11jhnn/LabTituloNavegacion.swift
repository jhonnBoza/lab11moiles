//
//  LabTituloNavegacion.swift
//  Iconos SF Symbols (nativos iOS, sin emojis)
//

import SwiftUI
import UIKit

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

enum LabNavigationTitle {

    static func aplicar(
        en viewController: UIViewController,
        simbolo: String,
        titulo: String,
        color: UIColor = .systemBlue
    ) {
        let icono = UIImageView(image: UIImage(systemName: simbolo))
        icono.tintColor = color
        icono.contentMode = .scaleAspectFit
        icono.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icono.widthAnchor.constraint(equalToConstant: 24),
            icono.heightAnchor.constraint(equalToConstant: 24)
        ])

        let label = UILabel()
        label.text = titulo
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label

        let stack = UIStackView(arrangedSubviews: [icono, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        viewController.navigationItem.titleView = stack
    }
}

enum LabIcono {

    static func imagen(simbolo: String, color: UIColor, tamaño: CGFloat = 32) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: tamaño, weight: .medium)
        return UIImage(systemName: simbolo, withConfiguration: config)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
