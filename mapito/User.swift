//
//  User.swift
//  mapito
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation

class User {
    func loginWithUsername(username : String, password : String) {
        //Valide le user et notifie root controller
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "loginActionFinished"),
            object: self,
            userInfo: nil)
    }
    
    func logout() {
        //Delete the account
    }
    
    func userAuthenticated() -> Bool{
        let auth : Bool = true;
        
        if(auth){
            return true;
        }
        
        return false;
    }
}
