//
//  TableCellRequest.swift
//  mapito
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class TableCellRequest: UITableViewCell {

    
    @IBOutlet weak var ButtonAcceptRequest: UIButton!
    var Mytoken : String!
    var displayMessage: ((String)->())? = nil
    
    //permet d'initialiser la table view a l'affichage
    override func awakeFromNib() {
        accessoryView = ButtonAcceptRequest
        imageView?.image = #imageLiteral(resourceName: "logo_mapito")
        
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.Mytoken = tokenIsValid
            print("Mytoken of button: "+self.Mytoken)
        }else {
            print("No token found");
        }
    }
    //clique deux fois
    @IBAction func AcceptRequestAction(_ sender: Any) {
        //print("test reussie")
        //lorsque l'on clique sur loe bouton on fait appel a la closure displayMessage
        //qui sera initialiser dans le FriendController qui l'appel
        displayMessage?("Voulez vous vraiment accepter la demande d'ami ?")
    }
}
