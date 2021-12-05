//
//  RegistrarViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 29/11/21.
//

import UIKit
import Firebase

class RegistrarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lblCorreoR: UITextField!
    @IBOutlet weak var lblPassR: UITextField!
    @IBOutlet weak var lblUser: UITextField!
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        //cambiar teclado en capo email
        lblCorreoR.keyboardType = .emailAddress
        
        //propiedades de la imagen
        imagenPerfil.layer.cornerRadius = imagenPerfil.frame.size.width/2
        imagenPerfil.clipsToBounds = true
        imagenPerfil.layer.borderWidth = 8
        
        //MARK: - agregar la opcion de tab a la imagen
        let gesturaRecognized = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gesturaRecognized.numberOfTapsRequired = 1
        gesturaRecognized.numberOfTouchesRequired = 1
        imagenPerfil.addGestureRecognizer(gesturaRecognized)
        imagenPerfil.isUserInteractionEnabled = true
    }
    
    //MARK: - metodo del clickImagen poniendo @objc por ser parte de ello
    @objc func clickImagen(gestura: UITapGestureRecognizer){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: - metodo seleccion de foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickerImage = info[.editedImage] as? UIImage else {return}
        imagenPerfil.image = userPickerImage
        
        //ocultar picker
        picker.dismiss(animated: true)
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
    
    //MARK: funcion ver si esta vavio el campo usuario
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
                    
                    self.db.collection("users").document(email).setData(["usuario": self.lblUser.text ?? "usuario"])
                    //ir al login
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
            }
        }
        }else{
            self.vacio()
        }
        
    }
    

}
