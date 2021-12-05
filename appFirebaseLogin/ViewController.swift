//
//  ViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 29/11/21.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var lblCorreoL: UITextField!
    @IBOutlet weak var lblPassL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mantener sesion
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String{
        self.performSegue(withIdentifier: "iniciarSesion", sender: self)
        }
    }
    
    //Al darle click a cuaquier parte se oculta el teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: alerta
    func mensajeAlerta(msg: String){
        let alerta = UIAlertController(title: "ERROR", message: msg, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: nil))
        present(alerta, animated: true, completion: nil)
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        if let email = lblCorreoL.text, let password = lblPassL.text{
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error{
                    
                    self.mensajeAlerta(msg: "Error: \(e.localizedDescription)")
                    
                }else{
                    self.performSegue(withIdentifier: "iniciarSesion", sender: self)
                }
                
            }
        }
        
    }

    
}

