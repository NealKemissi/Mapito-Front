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
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var ButtonDenyRequest: UIButton!
    @IBOutlet weak var ButtonAcceptRequest: UIButton!
    var Mytoken : String!
    var displayMessageAccept: ((String)->())? = nil
    var displayMessageDeny: ((String)->())? = nil
    
    //permet d'initialiser la table view a l'affichage
    override func awakeFromNib() {
        accessoryView = buttonsView
        imageView?.image = #imageLiteral(resourceName: "logo_mapito")
        self.backgroundColor = UIColor.clear;
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
        // When button tapped, call of displayMessage's closure
        // Will be initialized in FriendController when called
        displayMessageAccept?("Voulez vous vraiment accepter la demande d'ami ?")
    }
    
    @IBAction func DenyRequestAction(_ sender: Any) {
        displayMessageDeny?("Voulez vous vraiment supprimer la demande d'ami ?")
    }
}
