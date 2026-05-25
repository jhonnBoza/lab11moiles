//
//  DashboardViewController.swift
//  lab11jhnn — Menú principal del laboratorio S11
//

import UIKit
import SwiftUI
import SwiftData

struct LabActividad {
    let numero: String
    let titulo: String
    let subtitulo: String
    let icono: String
    let color: UIColor
}

final class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tabla = UITableView(frame: .zero, style: .insetGrouped)

    private let actividades: [LabActividad] = [
        LabActividad(
            numero: "01",
            titulo: "Contactos",
            subtitulo: "UIKit + Core Data",
            icono: "person.crop.circle.fill",
            color: .systemBlue
        ),
        LabActividad(
            numero: "02",
            titulo: "Alumnos",
            subtitulo: "SwiftUI + SwiftData",
            icono: "graduationcap.fill",
            color: .systemGreen
        ),
        LabActividad(
            numero: "03",
            titulo: "Productos",
            subtitulo: "SwiftUI + SwiftData · CRUD",
            icono: "shippingbox.fill",
            color: .systemOrange
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GLAB-S11"
        navigationItem.largeTitleDisplayMode = .never

        Task { @MainActor in
            LabSeedData.seedAllIfNeeded()
        }

        view.backgroundColor = .systemGroupedBackground
        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.delegate = self
        tabla.dataSource = self
        tabla.register(UITableViewCell.self, forCellReuseIdentifier: "ActividadCell")
        tabla.tableHeaderView = crearEncabezado()
        view.addSubview(tabla)

        NSLayoutConstraint.activate([
            tabla.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func crearEncabezado() -> UIView {
        let ancho = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: ancho, height: 92))

        let icono = UIImageView(image: UIImage(systemName: "externaldrive.fill.badge.icloud"))
        icono.tintColor = .systemIndigo
        icono.contentMode = .scaleAspectFit
        icono.translatesAutoresizingMaskIntoConstraints = false

        let titulo = UILabel()
        titulo.text = "Manejo de datos"
        titulo.font = .systemFont(ofSize: 22, weight: .bold)
        titulo.translatesAutoresizingMaskIntoConstraints = false

        let subtitulo = UILabel()
        subtitulo.text = "Core Data · SwiftData"
        subtitulo.font = .systemFont(ofSize: 15)
        subtitulo.textColor = .secondaryLabel
        subtitulo.translatesAutoresizingMaskIntoConstraints = false

        contenedor.addSubview(icono)
        contenedor.addSubview(titulo)
        contenedor.addSubview(subtitulo)

        NSLayoutConstraint.activate([
            icono.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 20),
            icono.centerYAnchor.constraint(equalTo: contenedor.centerYAnchor),
            icono.widthAnchor.constraint(equalToConstant: 44),
            icono.heightAnchor.constraint(equalToConstant: 44),
            titulo.leadingAnchor.constraint(equalTo: icono.trailingAnchor, constant: 14),
            titulo.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -20),
            titulo.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 20),
            subtitulo.leadingAnchor.constraint(equalTo: titulo.leadingAnchor),
            subtitulo.trailingAnchor.constraint(equalTo: titulo.trailingAnchor),
            subtitulo.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 4)
        ])

        return contenedor
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actividades.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Actividades del laboratorio"
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Tecsup · Programación en Móviles Avanzado"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ActividadCell", for: indexPath)
        let actividad = actividades[indexPath.row]

        var config = celda.defaultContentConfiguration()
        config.text = "Actividad \(actividad.numero): \(actividad.titulo)"
        config.secondaryText = actividad.subtitulo
        config.image = LabIcono.imagen(simbolo: actividad.icono, color: actividad.color, tamaño: 28)
        config.imageProperties.maximumSize = CGSize(width: 36, height: 36)
        celda.contentConfiguration = config
        celda.accessoryType = .disclosureIndicator
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0: abrirContactos()
        case 1: abrirAlumnos()
        case 2: abrirProductos()
        default: break
        }
    }

    private func abrirContactos() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let contactos = storyboard.instantiateViewController(withIdentifier: "ContactosVC") as? ContactosViewController else {
            return
        }
        navigationController?.pushViewController(contactos, animated: true)
    }

    private func abrirAlumnos() {
        let root = NavigationStack { AlumnosContentView() }
            .modelContainer(ModelContainerProvider.shared)
        navigationController?.pushViewController(UIHostingController(rootView: root), animated: true)
    }

    private func abrirProductos() {
        let root = NavigationStack { ProductosContentView() }
            .modelContainer(ProductoContainerProvider.shared)
        navigationController?.pushViewController(UIHostingController(rootView: root), animated: true)
    }
}
