//
//  ViewController.swift
//  MejiaSnapshat
//
//  Created by MacBook Pro on 31/05/23.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class IniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando Iniciar Sesión")
            if error != nil{
                print("Se presentó el siguiente error: \(error)")
            }else{
                print("Inicio de sesion exitoso")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loginGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in guard error == nil else { return }
            guard let user = result?.user, let idToken = user.idToken?.tokenString
            else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) {result, error in print("Se ha iniciado sesión con Google: \(String(describing: result))")}
        }
        
    }

    @IBAction func iniciarSesionGoogleTapped(_ sender: Any) {
        loginGoogle()
    }
    
}

