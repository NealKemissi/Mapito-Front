//
//  NewPinataController.swift
//  mapito
//
//  Created by m2sar on 06/06/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class NewPinataController: UIViewController {
    
    
    // API url
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    @IBInspectable var modifURL: String!
    
    private var user = User()
    var field : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        // Display of actual value
        print(self.field)
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            self.user.token = tokenIsValid
            let userDict = ["token": self.user.token, "field": field] as [String: AnyObject]
        }else {
            print("aucun token");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func setPinataYellow(_ sender: Any) {
        print("yellow Pinata")
        let userDict = ["token": self.user.token, "field": self.field, "value": "FCCA5F"] as [String: AnyObject]
        let stringUrl = env+self.modifURL!
        self.user.updateUser(url: stringUrl, userDict: userDict) { (response, data) in
            DispatchQueue.main.async {
                if(response == 200){
                    self.displayMessage(Mytitle: "Félicitations", userMessage: data);
                    return;
                } else {
                    self.displayMessage(Mytitle: "Attention", userMessage: "Une erreur est survenue");
                    return;
                }
            }
        }
    }
    
    @IBAction func setPinataRed(_ sender: Any) {
        print("red Pinata")
        let userDict = ["token": self.user.token, "field": self.field, "value": "F75469"] as [String: AnyObject]
        let stringUrl = env+self.modifURL!
        self.user.updateUser(url: stringUrl, userDict: userDict) { (response, data) in
            DispatchQueue.main.async {
                if(response == 200){
                    self.displayMessage(Mytitle: "Félicitations", userMessage: data);
                    return;
                } else {
                    self.displayMessage(Mytitle: "Attention", userMessage: "Une erreur est survenue");
                    return;
                }
            }
        }
    }
    
    @IBAction func setPinataGreen(_ sender: Any) {
        print("green Pinata")
        let userDict = ["token": self.user.token, "field": self.field, "value": "2AB573"] as [String: AnyObject]
        let stringUrl = env+self.modifURL!
        self.user.updateUser(url: stringUrl, userDict: userDict) { (response, data) in
            DispatchQueue.main.async {
                if(response == 200){
                    self.displayMessage(Mytitle: "Félicitations", userMessage: data);
                    return;
                } else {
                    self.displayMessage(Mytitle: "Attention", userMessage: "Une erreur est survenue");
                    return;
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayMessage(Mytitle: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: Mytitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
