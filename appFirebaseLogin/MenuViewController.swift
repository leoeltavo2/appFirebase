//
//  MenuViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 29/11/21.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    @IBOutlet weak var lblVerCorreo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //eliminar boton de regresar
        self.navigationItem.setHidesBackButton(true, animated: true)
        //obtener usuario
        let user = Auth.auth().currentUser
        lblVerCorreo.text = user?.email
        
        //mantener sesion
        if let email = Auth.auth().currentUser?.email{
            let defaults = UserDefaults.standard
            defaults.setValue(email, forKeyPath: "email")
            defaults.synchronize()
        }
        
    }
    
    @IBAction func btnCerrarSesion(_ sender: UIBarButtonItem) {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
        self.navigationController?.popViewController(animated: true)
        print("la sesion se cerro corrrectamente")
       } catch let signOutError as NSError {
         print("Error signing out: %@", signOutError)
       }
    }
    
    

}
