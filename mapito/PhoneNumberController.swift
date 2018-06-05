//
//  PhoneNumberController.swift
//  mapito
//
//  Created by m2sar on 05/06/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class PhoneNumberController: UIViewController {
    
    @IBOutlet weak var NewPhoneNumberTextField: UITextField!
    // API PATH
    @IBInspectable var modifURL: String!
    //@IBInspectable var valuePhoneURL : String!
    // API url
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    private var user = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Display of actual value
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            self.user.token = tokenIsValid
            print("token in tel Controller : ", self.user.token)
        }else {
            print("aucun token");
        }
    }
    
    //Modification Phone Number of the user
    @IBAction func ModificationPhone(_ sender: Any) {
        let newValuePhone = NewPhoneNumberTextField.text;
        // Field empty
        if((newValuePhone?.isEmpty)!){
            displayMessage(Mytitle: "Attention", userMessage: "Veuillez remplir correctement le champs");
            return;
        } else {
            // If field not empty -> update user phone number
            let userDict = ["token": self.user.token, "field": "numTel", "value": newValuePhone!] as [String: AnyObject]
            let stringUrl = env+self.modifURL!
            self.user.updateUser(url: stringUrl, userDict: userDict) { (response, data) in
                DispatchQueue.main.async {
                    if(response == 200){
                        self.displayMessage(Mytitle: "Félicitations", userMessage: "Votre numero de téléphone est bien rensigné");
                        return;
                    } else {
                        self.displayMessage(Mytitle: "Attention", userMessage: "Une erreur est survenue");
                        return;
                    }
                }
            }
        }
    }
    
    
    func displayMessage(Mytitle: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: Mytitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
