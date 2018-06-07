//
//  DetailedProfileController.swift
//  mapito
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class DetailedProfileController: UIViewController {
    @IBOutlet weak var newValueTextField: UITextField!
    @IBOutlet weak var confirmNewValueTextField: UITextField!
    @IBOutlet weak var valueField: UILabel!
    
    // API paths
    @IBInspectable var modifURL: String!
    @IBInspectable var userFieldURL: String! //recuperation de l'attribut du user (ex: recup mail ou recup prenom etc..)
    
    // API url
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Local variables
    var myValue : String?
    private var user = User()
    var field : String = ""
    
    @IBAction func modificationValue(_ sender: Any) {
        let newValue = newValueTextField.text;
        let confirm = confirmNewValueTextField.text;
        
        // Fields empty
        if((newValue?.isEmpty)! || (confirm?.isEmpty)!){
            displayMessage(Mytitle: "Attention", userMessage: "Veuillez remplir correctement tous les champs");
            return;
        // Fields do not correspond
        }else if((newValue != confirm)){
            displayMessage(Mytitle: "Attention", userMessage: "Les valeurs ne correspondent pas");
            return;
        } else {
            // If fields not empty and do correspond -> update user infos
            let userDict = ["token": self.user.token, "field": self.field, "value": confirm!] as [String: AnyObject]
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Display of actual value
        valueField?.text = "Modifier "+field
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            self.user.token = tokenIsValid
            let userDict = ["token": self.user.token, "field": field] as [String: AnyObject]
            
            let stringUrl = env+self.userFieldURL!
            
            self.user.getFieldValue(url: stringUrl, callback: { (response) in
                self.myValue = response
                print(self.myValue)
            })
        }else {
            print("aucun token");
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
