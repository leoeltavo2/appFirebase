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
import StoreKit

class MenuViewController: UIViewController {
    var menu: SideMenuNavigationController?
    
    var modeles = [SKProduct]()

    var titulo = ["banderillas", "taza cafe", "cake pope","taza capuccino","carne asada","churros","hamburguesa a la Parrilla","pan","pancakes","papas ucranianas","pasta","pasta Pesto","pastel","pastel de fruta","pizza","pizza Italiana","postre de Fresas","salmon", "sandia"]
    var precio = ["$25.00 MXN","$12.00 MXN","$10.00 MXN","$18.00 MXN","$45.00 MXN","$8.00 MXN","$32.00 MXN","$5.00 MXN","$12.00 MXN","$25.00 MXN","$25.00 MXN","$30.00 MXN","$22.50 MXN","$20.00 MXN","$100.00 MXN","$150.00 MXN","$34.00 MXN","$54.00 MXN","$25.00 MXN"]
    var descripcion = ["Banderillas de carne con pimientos.", "Taza de cafe con granos importados de francia.", "Cake popes.","Taza de nuestro mejor capuccino.","Carne sada artesanal.","Deliciosos churros hechos al momento.","Hamburguesa a la parilla. Las mejores del continente.","Pan calientito recien horneado.","Pancakes suavecitos.","Papas importadas desde ucraniana.","Pasta a lo italiano.","Pasta pesto de italia.","Pastel de moka.","Pastel de fruta.","Pizza con 1 ingrediente.","Pizza italiana.","Postre de fresas rojas recien cortadas.","Pieza de Salmon.", "Sandia dulce."]
    var imagenes = ["banderillas", "cafe", "cakepops","cappuccino","carne","churros","hamburgesaParrilla","pan","pancakes","papasUcranianas","pasta","pastaPesto","pastel","pastelFruta","pizza","pizzaItaliana","postreFresas","salmon", "sandia"]
    
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email
    
    @IBOutlet weak var tablaProducto: UITableView!
    
//    MARK: DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        //Menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        //eliminar boton de regresar
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //payment
        SKPaymentQueue.default().add(self)
        
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
        
        buscarProducto()
        //llamar gasto
//        db.collection("users").document(email!).getDocument { (documentSnapshot, error) in
//            if let document = documentSnapshot, error == nil{
//                if let gasto = document.get("gasto") as? Int{
//                    self.lblGastado.text = "$\(gasto) MXN"
//                }
//            }
//        }
        
    }
    
   
    
    
    
//    MARK: FUNCION CERRAR SESION
    func cerrarSesion(){
            let alerta = UIAlertController(title: "SALIR", message: "??Desea cerrar sesi??n?", preferredStyle: .alert)
        
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
    
    
//    MARK: funcion obtener productos

    func buscarProducto(){
        let request = SKProductsRequest(productIdentifiers: Set(titulo))
        request.delegate = self
        request.start()
    }
    
    
}


//MARK: extension table view
extension MenuViewController: UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver{
   
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaProducto.deselectRow(at: indexPath, animated: true)
        //mostar compra
        let payment = SKPayment(product: modeles[indexPath.row])
        SKPaymentQueue.default().add(payment)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.modeles = response.products
            self.tablaProducto.reloadData()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //
        transactions.forEach({
            switch $0.transactionState{
            case .purchasing:
                print("comprando")
            case .purchased:
                print("comprado")
                
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("no se compro")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored: break
            case .deferred: break
            @unknown default: break
            }
        })
    }
    
}

