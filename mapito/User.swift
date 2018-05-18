//
//  User.swift
//  mapito
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class User {
    
    
    var nom : String;
    var prenom : String;
    var mail : String;
    var password : String;
    var friends : [Friend];
    var pos : MKUserLocation;
    
    init(nom: String, prenom: String, mail: String, password: String, friends: [Friend]){
        self.nom = nom;
        self.prenom = prenom;
        self.mail = mail;
        self.password = password;
        self.friends = friends;
        self.pos = MKUserLocation() ;
    }
    
    
    
    
    func loginWithUsername(username : String, password : String) {
        //Valide le user et notifie root controller
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "loginActionFinished"),
            object: self,
            userInfo: nil)
    }
    
    func register(nom: String, prenom: String, pseudo:String, mail: String, password: String) {
        
    }
    
    func logout() {
        //Delete the account
    }
    
    func userAuthenticated() -> Bool{
        let auth : Bool = true;
        
        return auth;
    }
}
