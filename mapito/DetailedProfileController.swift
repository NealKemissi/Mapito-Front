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
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    @IBOutlet weak var newValueTextField: UITextField!
    @IBOutlet weak var confirmNewValueTextField: UITextField!
    var myValue : String?
    private var user = User()
    var field : String = ""
    @IBOutlet weak var valueField: UILabel!
    //path de la methode modification attributs
    @IBInspectable var modifURL: String!
    @IBInspectable var userFieldURL: String! //recuperation de l'attribut du user (ex: recup mail ou recup prenom etc..)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //affichage de la valeur actuelle
        valueField?.text = "Modifier "+field
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
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
        // Dispose of any resources that can be recreated.
    }
    
    //lorsque le user clique sur modifier
    @IBAction func modificationValue(_ sender: Any) {
        let newValue = newValueTextField.text;
        let confirm = confirmNewValueTextField.text;
        
        //verif champs vide
        if((newValue?.isEmpty)! || (confirm?.isEmpty)!){
            displayMessage(Mytitle: "Attention", userMessage: "Veuillez remplir correctement tous les champs");
            return;
        }else if((newValue != confirm)){
            displayMessage(Mytitle: "Attention", userMessage: "Les valeurs ne correspondent pas");
            return;
        } else {
            //Si les champs ne sont pas vide et correspondent, alors appel methode d' inscription
            let userDict = ["token": self.user.token, "field": self.field, "value": confirm!] as [String: AnyObject]
            let stringUrl = env+self.modifURL!
            self.user.updateUser(url: stringUrl, userDict: userDict) { (response) in
                DispatchQueue.main.async {
                    if(response == "200"){
                        self.displayMessage(Mytitle: "Félicitations", userMessage: "Vous avez changé votre profil");
                        return;
                    } else if(response == "403") {
                        self.displayMessage(Mytitle: "Désolé", userMessage: "Ce mail existe déja");
                        return;
                    } else {
                        self.displayMessage(Mytitle: "Oups", userMessage: "Problème inconnu");
                        return;
                    }
                }
            }
        }
    }
    
    //message info
    func displayMessage(Mytitle: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: Mytitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
