//
//  EditarViewController.swift
//  ContactosCoreData
//
//  Created by Jorge Luis Baltazar Perez on 19/05/21.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {
    
    //areglo de contactos
    var contactos = [Contacto]()

    //conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var recibirNombre: String?
    var recibirTel: Int64?
    var recibirDireccion: String?
    var indice: Int?
    var recibirCorreo: String?

    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var ImagenPerfil: UIImageView!
    @IBAction func cancelarButton(_ sender: UIButton) {
        //regresar cuando hay NVC
        navigationController?.popViewController(animated: true)
    }
    @IBAction func guardarButton(_ sender: UIButton) {
        do {
            contactos[indice!].setValue(nombreTextField.text, forKeyPath: "nombre")
            contactos[indice!].setValue(Int64(telefonoTextField.text!), forKeyPath: "telefono")
            contactos[indice!].setValue(direccionTextField.text, forKeyPath: "direccion")
            contactos[indice!].setValue(ImagenPerfil.image?.pngData(), forKeyPath: "imagen")
            contactos[indice!].setValue(correoTextField.text, forKey: "correo")
           
            //regresar con NVC
            navigationController?.popViewController(animated: true)
            
            try self.contexto.save()
            print("se actualizo el contexto")
        } catch  {
            print("Error al actualizar: \(error.localizedDescription)")
        }
    }
    @IBAction func tomarFotoButton(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    @IBOutlet weak var nombreTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreTextField.text = recibirNombre
        telefonoTextField.text = "\(recibirTel ?? 000)"
        direccionTextField.text = recibirDireccion
        correoTextField.text = recibirCorreo
        
        cargarCoreData()
        ImagenPerfil.image = UIImage(data: contactos[indice!].imagen!)
        print("indice: \(indice)")
        
        //agregar textura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        
        gestura.numberOfTapsRequired = 1
        
        //numero de toques
        gestura.numberOfTouchesRequired = 1
        
        //agregar la textura a la imagen
        ImagenPerfil.addGestureRecognizer(gestura)
        ImagenPerfil.isUserInteractionEnabled = true
        
        
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    
    
    @objc func clickImagen(gestura: UITapGestureRecognizer){
        print("Cambiar Imagen")
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
   
}



extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            ImagenPerfil.image = imagenSeleccionada
        }
      
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
