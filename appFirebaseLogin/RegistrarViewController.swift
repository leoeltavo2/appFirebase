//
//  RegistrarViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 29/11/21.
//

import UIKit
import Firebase
import FirebaseStorage

class RegistrarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblCorreoR: UITextField!
    @IBOutlet weak var lblPassR: UITextField!
    @IBOutlet weak var lblUser: UITextField!
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        //cambiar teclado en capo email
        lblCorreoR.keyboardType = .emailAddress
        
        //sombra en el view
        viewShadow.layer.shadowColor = UIColor.darkGray.cgColor
        viewShadow.layer.shadowRadius = 20
        viewShadow.layer.shadowOpacity = 0.5
        viewShadow.layer.shadowOffset = CGSize(width: 1, height: 0)
        
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
    
    //MARK: funcion ver si esta vacio el campo usuario
    func vacio(){
            let alerta = UIAlertController(title: "ERROR", message: "complete el campo de usuario", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
        
    }
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        if !self.lblUser.text!.isEmpty{
           
        if let email = lblCorreoR.text, let password = lblPassR.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    
                    self.mensajeAlerta(msg: "Error: \(e.localizedDescription)")
                }else{
                    
                    let alerta = UIAlertController(title: "EXITO", message: "usuario creado correctamente", preferredStyle: .alert)

                    alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
                        
                        
                        //email
                        self.db.collection("users").document(email).setData(["usuario": self.lblUser.text!, "email": self.lblCorreoR.text!])
                        //ir al login
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alerta, animated: true, completion: nil)
                    
                    
                }
            }
        }
        }else{
            self.vacio()
        }
        
    }
    

}
