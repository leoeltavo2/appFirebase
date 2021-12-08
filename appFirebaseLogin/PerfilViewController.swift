//
//  PerfilViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 06/12/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class PerfilViewController: UIViewController {

    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var tfGetUsuario: UITextField!
    @IBOutlet weak var tfGetCorreo: UITextField!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //propiedades de la imagen
        imagenPerfil.layer.cornerRadius = imagenPerfil.frame.size.width/2
        imagenPerfil.clipsToBounds = true
        imagenPerfil.layer.borderWidth = 4

        //sombra en el view
        viewShadow.layer.shadowColor = UIColor.darkGray.cgColor
        viewShadow.layer.shadowRadius = 20
        viewShadow.layer.shadowOpacity = 0.5
        viewShadow.layer.shadowOffset = CGSize(width: 1, height: 0)
        
        obtenerInfo()
        
        
    }
    
    //Al darle click a cuaquier parte se oculta el teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func btnEditar(_ sender: UIButton) {
        guardarInfo()
        let alerta = UIAlertController(title: "EXITO", message: "usuario modificado correctamente", preferredStyle: .alert)

        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            
            //ir al login
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func btnCancelar(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //funcion obtener informacion
    func obtenerInfo(){
        let userEmail = Auth.auth().currentUser?.email
//        let user = Auth.auth().currentUser
//        let ID = Auth.auth().currentUser?.uid

        tfGetCorreo.text = userEmail
        db.collection("users").document(userEmail!).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil{
                if let usuario = document.get("usuario") as? String{
                    self.tfGetUsuario.text = usuario
                }
            }
        }
        
        //obtener imagen usuario
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let ref = storageRef.child("imagen")
        imagenPerfil.sd_setImage(with: ref)
    }
    
    //funcion guardar informacion
    func guardarInfo(){
        let userEmail = Auth.auth().currentUser?.email
//        let userID = Auth.auth().currentUser?.uid
        let user = Auth.auth().currentUser
//        print("usuarioooooo: \(user?.email!)")
        //llamar nombre usuario
        if tfGetUsuario != nil && tfGetCorreo != nil{
            db.collection("users").document(userEmail!).updateData(["usuario": tfGetUsuario.text!, "email": tfGetCorreo.text!])
            if tfGetCorreo.text != userEmail{
                user?.updateEmail(to: tfGetCorreo.text!){error in
                    if let e = error{
                        print(e)
                    }
                    
                }
            }
        }
        
        
  }
}


//MARK: funcion ver si esta vacio el campo usuario
//func vacio(){
//        let alerta = UIAlertController(title: "ERROR", message: "complete el campo de usuario", preferredStyle: .alert)
//        alerta.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: nil))
//        self.present(alerta, animated: true, completion: nil)
//
//
//}
