//
//  ImagenViewController.swift
//  MejiaSnapshat
//
//  Created by MacBook Pro on 7/06/23.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var elegirContactoButton: UIButton!
    @IBOutlet weak var descripcionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        elegirContactoButton.isEnabled = false
    }
    

    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
     @IBAction func elegirContactoTapped(_ sender: Any) {
         self.elegirContactoButton.isEnabled = false
         let imagenesFolder = Storage.storage().reference().child("imagenes")
         let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
         let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
         cargarImagen.putData(imagenData!, metadata: nil) {(metadata, error) in
             if error != nil {
                 self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexión a internet o vuelva a intentarlo", action: "Aceptar")
                 self.elegirContactoButton.isEnabled = true
                 print("Ocurrio un error al subir la imagen \(error)")
             }else{
                 cargarImagen.downloadURL(completion: {(url, error) in
                     guard let enlaceURL = url else{
                         self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la información de la imagen", action: "Cancelar")
                         self.elegirContactoButton.isEnabled = true
                         print("Ocurrio un error al obtener la información de la imagen \(error)")
                         return
                     }
                     self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                 })
                 
             }
         }
         /*let alertaCarga = UIAlertController(title: "Cargando Imagen...", message: "0%", preferredStyle: .alert)
         let progresoCarga : UIProgressView = UIProgressView(progressViewStyle: .default)
         cargarImagen.observe(.progress) { (snapshot) in
             let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
             print(porcentaje)
             progresoCarga.setProgress(Float(porcentaje), animated: true)
             progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
             alertaCarga.message = String(round(porcentaje*100.0)) + " %"
             if porcentaje>=1.0 {
                 alertaCarga.dismiss(animated: true, completion: nil)
             }
         }
         let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
         alertaCarga.addAction(btnOK)
         alertaCarga.view.addSubview(progresoCarga)
         present(alertaCarga, animated: true)
          */
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, action: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: action, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
    }

}
