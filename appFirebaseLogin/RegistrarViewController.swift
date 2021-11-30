//
//  RegistrarViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 29/11/21.
//

import UIKit
import Firebase

class RegistrarViewController: UIViewController {

    @IBOutlet weak var lblCorreoR: UITextField!
    @IBOutlet weak var lblPassR: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: alerta
    func mensajeAlerta(msg: String){
        let alerta = UIAlertController(title: "ERROR", message: msg, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        if let email = lblCorreoR.text, let password = lblPassR.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    
                    self.mensajeAlerta(msg: "Error: \(e.localizedDescription)")
                }else{
                    //ir al login
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        
    }
    

}
