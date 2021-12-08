//
//  MenuViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 29/11/21.
//

import UIKit
import Firebase
import SideMenu
import FirebaseStorage

class MenuViewController: UIViewController {
    var menu: SideMenuNavigationController?

    var titulo = ["banderillas", "taza cafe", "cake pope","taza capuccino","carne asada","churros","hamburguesa a la Parilla","pan","pancakes","papas Ucranianas","pasta","pasta Pesto","pastel","pastel deFruta","pizza","pizza Italiana","postre de Fresas","salmon", "sandia"]
    var precio = ["$25.00 MXN","$12.00 MXN","$10.00 MXN","$18.00 MXN","$45.00 MXN","$8.00 MXN","$32.00 MXN","$5.00 MXN","$12.00 MXN","$25.00 MXN","$25.00 MXN","$30.00 MXN","$22.50 MXN","$100.00 MXN","$120.00 MXN","$15.00 MXN","$34.00 MXN","$54.00 MXN","$25.00 MXN"]
    var descripcion = ["banderillas", "cafe", "cakepope","capuccino","carne","churros","hamburguesaParilla","pan","pancake","papasUcranianas","pasta","pastaPesto","pastel","pastelFruta","pizza","pizzaItaliana","postreFresas","salmon", "sandia"]
    var imagenes = ["banderillas", "cafe", "cakepops","cappuccino","carne","churros","hamburgesaParrilla","pan","pancakes","papasUcranianas","pasta","pastaPesto","pastel","pastelFruta","pizza","pizzaItaliana","postreFresas","salmon", "sandia"]
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tablaProducto: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        //eliminar boton de regresar
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //mantener sesion
        if let email = Auth.auth().currentUser?.email{
            let defaults = UserDefaults.standard
            defaults.setValue(email, forKeyPath: "email")
            defaults.synchronize()
        }
        
        //registrar celda
        tablaProducto.register(UINib(nibName: "celdaPrincipalPersonalizada", bundle: nil), forCellReuseIdentifier: "celda")
        
        tablaProducto.delegate = self
        tablaProducto.dataSource = self
        
        
        
     
    }
    
   
    
    
    
//    MARK: FUNCION CERRAR SESION
    func cerrarSesion(){
            let alerta = UIAlertController(title: "SALIR", message: "¿Desea cerrar sesión?", preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default) { _ in
            
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
        
        alerta.addAction(accionAceptar)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
            self.present(alerta, animated: true, completion: nil)
            
        
    }
//    MARK: BUTON CERRAR SESION
    @IBAction func btnCerrarSesion(_ sender: UIBarButtonItem) {
        cerrarSesion()
    }
    
    
       
     
      
    
}


//MARK: extension table view
extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let celda = tablaProducto.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! celdaPrincipalPersonalizada
        celda.lblTitulo.text = titulo[indexPath.row]
        celda.lblDescripcion.text = descripcion[indexPath.row]
        celda.lblPrecio.text = precio[indexPath.row]
        celda.imgComida.image = UIImage(named: imagenes[indexPath.row])
        
//        db.collection("images").document().getDocument{ (documentSnapshot, error) in
//            if let document = documentSnapshot, error == nil{
//                if let titulo = document.get("titulo") as? String{
//                    celda.lblTitulo.text = titulo
//                    print(" el titulo es \(titulo) " )
//                }
//            }
//        }
        
        return celda
    }
    
    
}

