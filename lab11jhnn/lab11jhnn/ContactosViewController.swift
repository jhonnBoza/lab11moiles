//
//  ContactosViewController.swift
//  lab11jhnn — Actividad 01
//

import UIKit
import CoreData

class ContactosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TablaContacto: UITableView!

    var contactos = [Contacto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        LabNavigationTitle.aplicar(en: self, simbolo: "person.2.fill", titulo: "Lista de Contactos - Tecsup", color: .systemBlue)
        navigationItem.largeTitleDisplayMode = .never
        TablaContacto.delegate = self
        TablaContacto.dataSource = self
        LabSeedData.seedContactosIfNeeded()
        leerContactos()
    }

    func conexion() -> NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func leerContactos() {
        let contexto = conexion()
        let solicitud = NSFetchRequest<Contacto>(entityName: "Contacto")
        do {
            contactos = try contexto.fetch(solicitud)
            TablaContacto.reloadData()
        } catch {
            print("Error al leer: \(error)")
        }
    }

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Agregar Contacto", message: "Nuevo Contacto", preferredStyle: .alert)

        alerta.addTextField { $0.placeholder = "Nombre" }
        alerta.addTextField { campo in
            campo.placeholder = "Telefono"
            campo.keyboardType = .phonePad
        }
        alerta.addTextField { $0.placeholder = "Direccion" }

        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let contexto = self.conexion()
            let nuevo = Contacto(context: contexto)
            nuevo.nombre = alerta.textFields?[0].text ?? ""
            nuevo.telefono = alerta.textFields?[1].text ?? ""
            nuevo.direccion = alerta.textFields?[2].text ?? ""
            do {
                try contexto.save()
                self.leerContactos()
            } catch {
                print("Error al guardar: \(error)")
            }
        })
        alerta.addAction(UIAlertAction(title: "cancelar", style: .cancel))
        present(alerta, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = TablaContacto.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let c = contactos[indexPath.row]
        celda.textLabel?.text = c.nombre
        celda.detailTextLabel?.text = "\(c.telefono ?? "") | \(c.direccion ?? "")"
        return celda
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eliminarContacto(at: indexPath)
        }
    }

    func eliminarContacto(at indexPath: IndexPath) {
        let contexto = conexion()
        contexto.delete(contactos[indexPath.row])
        do {
            try contexto.save()
            contactos.remove(at: indexPath.row)
            TablaContacto.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error al eliminar: \(error)")
        }
    }
}
