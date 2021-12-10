//
//  MenuDesplegableViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 04/12/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class MenuDesplegableViewController: UIViewController {
    @IBOutlet weak var imgPerfilIcono: UIImageView!
    @IBOutlet weak var lblPerfilUsuario: UILabel!
    @IBOutlet weak var tablaConfig: UITableView!
    
    var nombreConfig = ["Mi perfìl", "Mapa", "Acerca de"]
    var img = ["person.fill", "map" , "info"]
    var obtenerIndex: Int?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPerfilIcono.image = UIImage(systemName: "person")

        tablaConfig.register(UINib(nibName: "celdaConfig", bundle: nil), forCellReuseIdentifier: "celda")
        
        tablaConfig.delegate = self
        tablaConfig.dataSource = self
        tablaConfig.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.84, alpha:1.0)
        
        //propiedades de la imagen
        imgPerfilIcono.layer.cornerRadius = imgPerfilIcono.frame.size.width/2
        imgPerfilIcono.clipsToBounds = true
        imgPerfilIcono.layer.borderWidth = 1
        
        //llamar nombre usuario
        let emailUser = Auth.auth().currentUser?.email
        
        db.collection("users").document(emailUser!).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil{
                if let usuario = document.get("usuario") as? String{
                    self.lblPerfilUsuario.text = usuario
                }
            }
        }
        
        //obtener imagen usuario
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let ref = storageRef.child("\(emailUser!)")
        imgPerfilIcono.sd_setImage(with: ref)
    }
    
}

extension MenuDesplegableViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombreConfig.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaConfig.dequeueReusableCell(withIdentifier: "celda", for:indexPath) as! celdaConfig
        celda.lblConfig.text = nombreConfig[indexPath.row]
        celda.imgConfig.image = UIImage(systemName: img[indexPath.row])
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        obtenerIndex = indexPath.row
        
        //obtener indexpath para mandar al menu
        switch obtenerIndex{
        case 0: performSegue(withIdentifier: "seguePerfil", sender: self)
        case 1: performSegue(withIdentifier: "segueMapa", sender: self)
        case 2: performSegue(withIdentifier: "segueAcerca", sender: self)
            
        default:print("nada por mostrar")
            
        }
        
    }
    
}
