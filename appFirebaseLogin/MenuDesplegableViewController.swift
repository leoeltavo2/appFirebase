//
//  MenuDesplegableViewController.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 04/12/21.
//

import UIKit

class MenuDesplegableViewController: UIViewController {
    var nombreConfig = ["Inicio", "Configuración", "Acerca de", "Salir"]
    var img = ["house", "person.badge.plus", "info", "clear"]
    
    @IBOutlet weak var tablaConfig: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tablaConfig.register(UINib(nibName: "celdaConfig", bundle: nil), forCellReuseIdentifier: "celda")
        
        tablaConfig.delegate = self
        tablaConfig.dataSource = self
        tablaConfig.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.84, alpha:1.0)
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
    //aqui
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
}
