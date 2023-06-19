//
//  RegistrarViewController.swift
//  MejiaSnapshat
//
//  Created by MacBook Pro on 11/06/23.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrarViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func registrarseTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
            print("Intentando crear un usuario")
            if error != nil{
                print("Se presentó un error al crear un usuario: \(error)")
            }else{
                print("El usuario fue creado exitosamente")
                
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creación de usuario", message: "Usuario", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
                })
                alerta.addAction(btnOK)
                self.present(alerta, animated: true)
                
                self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
            }}
        )
        
    }
}

