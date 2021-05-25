//
//  ViewController.swift
//  ContactosCoreData
//
//  Created by Jorge Luis Baltazar Perez on 18/05/21.
//

import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController {
    
    var nombreEnviar: String?
    var telefonoEnviar: Int64?
    var direccionEnviar: String?
    var indiceEnviar: Int?
    var correoEnviar: String?
    
    //areglo de contactos
    var contactos = [Contacto]()
    
    //conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func agregarContacto(_ sender: Any) {
        let alerta = UIAlertController(title: "Agregar", message: "Nuevo contacto", preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            
            guard let nombreAlert = alerta.textFields?.first?.text else{return}
            
            guard let telefonoAlert = Int64(alerta.textFields?[1].text ?? "000000") else
            {return}
            
            guard let direccionAlert = alerta.textFields?[2].text else
            {return}
            
            let imagenTemporal = UIImageView(image: #imageLiteral(resourceName: "contacto-1"))
            
            guard let correoAlert = alerta.textFields?.last?.text else
            {return}
            
            //Crear el objeto para guardar en coredata
            
            let nuevoContacto = Contacto(context: self.contexto)
            nuevoContacto.nombre = nombreAlert
            
            nuevoContacto.telefono = telefonoAlert
            
            nuevoContacto.direccion = direccionAlert
            
            nuevoContacto.imagen = imagenTemporal.image!.pngData()
            
            nuevoContacto.correo = correoAlert
            
            self.contactos.append(nuevoContacto)
            self.guardarContacto()
            self.tablaContactos.reloadData()
            print("Correo \(nuevoContacto.correo)")
        }
        
        alerta.addTextField { (nombreTF) in
            nombreTF.placeholder = "Nombre"
            nombreTF.autocapitalizationType = .words
        }
        alerta.addTextField { (telefonoTF) in
            telefonoTF.placeholder = "Teléfono"
            telefonoTF.keyboardType = .numberPad
        }
        alerta.addTextField { (direccionTF) in
            direccionTF.placeholder = "Dirección"
        }
        alerta.addTextField { (correoTF) in
            correoTF.placeholder = "Correo electrónico"
        }
        
        alerta.addAction(accionAceptar)
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(accionCancelar)
        
        present(alerta, animated: true)
    }
    
    //Guardar
    func guardarContacto(){
        do {
            try contexto.save()
            print("Se guardo el contexto")
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    //Leer
    func cargarCoreData(){
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch  {
            print("Error al cargar datos de core data: \(error.localizedDescription)")
        }
    }
    
    @IBOutlet weak var tablaContactos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaContactos.delegate = self
        tablaContactos.dataSource = self
        
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "celdaContacto")
        
        
        //leer los datos de la bd de core data
        cargarCoreData()
        tablaContactos.reloadData()
    }
    
    //Se manda a llamar cada que la vista aparece
    override func viewWillAppear(_ animated: Bool) {
        print("Aparecio la vista")
        tablaContactos.reloadData()
    }


}

//para usar table view
extension ViewController: UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //show error alert
            controller.dismiss(animated: true)
            return
        }
        
        
        switch result {
        case .cancelled:
            print("Cancelado")
            showAlert(msj: "Cancelled")
        case .failed:
            print("Error al enviar msj")
            showAlert(msj: "Error to send msj")
        case .saved:
            print("Guardado en borradores!")
            showAlert(msj: "Saved ind drafts")
        case .sent:
            print("Correo enviado!")
            showAlert(msj: "email sent")
        default:
            print("error desconocido")
            showAlert(msj: "uknown error")
        }
        
        controller.dismiss(animated: true)
    }
    func showAlert(msj: String) {
        let alert = UIAlertController(title: "Notificacion", message: msj, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: msj, style: .default, handler: nil))
        present(alert, animated: true)
        
    }
    
    
    //retornar cantidad de renglones
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    //retornar el objeto  celda a la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "celdaContacto", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = contactos[indexPath.row].nombre
        celda.telefonoLabel.text = "📞 \(contactos[indexPath.row].telefono ?? 00000)"
        celda.contactoImagen.image = UIImage(data: contactos[indexPath.row].imagen!)
        return celda
    }
    //Hacer mas alta la celda
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaContactos.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        telefonoEnviar = contactos[indexPath.row].telefono
        direccionEnviar = contactos[indexPath.row].direccion
        indiceEnviar = indexPath.row
        correoEnviar = contactos[indexPath.row].correo
        performSegue(withIdentifier: "editarContactos", sender: self)
    }
    
    //enviar parametros
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContactos"{
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirNombre = nombreEnviar
            objEditar.recibirTel = telefonoEnviar
            objEditar.recibirDireccion = direccionEnviar
            objEditar.indice = indiceEnviar
            objEditar.recibirCorreo = correoEnviar
        }
    }
    
    //Metodos SwipeActions
    
    //SWA -- Desde la izquierda
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionBorrar = UIContextualAction(style: .normal, title: "") { (_ ,_ ,_) in
            print("Borrar")
            //eliminar de coredata
            self.contexto.delete(self.contactos[indexPath.row])
            //eliminar de la interfaz grafica
            self.contactos.remove(at: indexPath.row)
            
            self.guardarContacto()
            self.tablaContactos.reloadData()
        }
        accionBorrar.image = UIImage(named: "borrar.png")
        accionBorrar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [accionBorrar])
    }
    
    //SWA -- Desde la derecha
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionLlamada = UIContextualAction(style: .normal, title: "") { (_ ,_ ,_) in
            print("Llamada")
            
            guard let telefono = self.contactos[indexPath.row].value(forKey: "telefono") else {return}
            
            if let phoneCallURL = URL(string: "TEL://+52\(telefono)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)

                }

            }
        }
        
        accionLlamada.image = UIImage(named: "llamada.png")
        accionLlamada.backgroundColor = .green
        
       
        
        
        return UISwipeActionsConfiguration(actions: [accionLlamada])
    }
    
}
