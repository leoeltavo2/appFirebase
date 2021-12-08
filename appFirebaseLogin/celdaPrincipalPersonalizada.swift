//
//  celdaPrincipalPersonalizada.swift
//  appFirebaseLogin
//
//  Created by Mac3 on 07/12/21.
//

import UIKit

class celdaPrincipalPersonalizada: UITableViewCell {

    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var imgComida: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblPrecio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //sombra en el view
        viewShadow.layer.shadowColor = UIColor.darkGray.cgColor
        viewShadow.layer.shadowRadius = 20
        viewShadow.layer.shadowOpacity = 0.5
        viewShadow.layer.shadowOffset = CGSize(width: 1, height: 0)
    }
  
    
}
