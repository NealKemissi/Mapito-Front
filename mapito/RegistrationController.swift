//
//  RegistrationController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class RegistrationController : UIViewController {
    @IBOutlet weak var userNomTextField: UITextField!
    @IBOutlet weak var userPrenomTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userMdpTextField: UITextField!
    
    //API paths
    @IBInspectable var registerURL: String!
    
    // API URL
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Local variables
    var user = User()  
    
    @IBAction func inscriptionButtonAction(_ sender: Any) {
        let userNom = userNomTextField.text;
        let userPrenom = userPrenomTextField.text;
        let userEmail = userEmailTextField.text;
        let userMdp = userMdpTextField.text;
        
        //verif champs vide
        if((userNom?.isEmpty)! || (userPrenom?.isEmpty)! || (userEmail?.isEmpty)! || (userMdp?.isEmpty)!){
            displayMessage(Mytitle: "Attention", userMessage: "Veuillez remplir correctement tous les champs");
            return;
        }
        //To do in user model
        self.user = User(nom: userNom!, prenom: userPrenom!, mail: userEmail!, password: userMdp!)
        let stringUrl = env + self.registerURL
        self.user.register(url: stringUrl) { (response, data) in
            DispatchQueue.main.async {
                if(response == 200){
                    self.displayMessage(Mytitle: "Félicitations", userMessage: data);
                    return;
                } else {
                    self.displayMessage(Mytitle: "Attention", userMessage: data);
                    return;
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayMessage(Mytitle: String ,userMessage: String)
    {
        let myAlert = UIAlertController(title: Mytitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
