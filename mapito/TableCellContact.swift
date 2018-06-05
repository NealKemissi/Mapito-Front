//
//  TableCellContact.swift
//  mapito
//
//  Created by m2sar on 05/06/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class TableCellContact: UITableViewCell {
    var Mytoken : String!
    var displayMessageAccept: ((String)->())? = nil
    @IBOutlet weak var buttonAcceptContact: UIButton!
    var displayMessageAcceptC: ((String)->())? = nil
    
    override func awakeFromNib() {
        accessoryView = buttonAcceptContact
        imageView?.image = #imageLiteral(resourceName: "logo_mapito")
        
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.Mytoken = tokenIsValid
            print("Mytoken of button: "+self.Mytoken)
        }else {
            print("No token found");
        }
    }
    
    @IBAction func acceptContactAction(_ sender: Any) {
        displayMessageAcceptC?("Voulez vous vraiment envoyer la demande d'ami ?")
        
    }
    
}
