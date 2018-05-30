//
//  NotificationsController.swift
//  mapito
//
//  Created by m2sar on 30/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class NotificationsController: UIViewController {
    
    var Mytoken : String = "test"
    @IBInspectable var MyNotifsURL: String!
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.Mytoken = tokenIsValid
            print("Mytoken: "+self.Mytoken)
        }else {
            print("aucun token");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Demander au prof
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: Selector(("loadList:")), name: Notification.Name(rawValue: "mapControllerRefresh"), object: nil)
    }
    
    func loadList(notification: Notification){
        //notification.
    }
}
