//
//  NewFriendController.swift
//  mapito
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class NewFriendController: UIViewController {
    
    @IBOutlet weak var EmailFriendTextField: UITextField!
    //path de la methode modification ajout amis
    @IBInspectable var addFriendURL: String!
    var friendResearchValue = ""
    private var user = User()
    @IBOutlet weak var friendResearchTextField: UITextField!
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendResearchTextField.text = self.friendResearchValue
        self.friendResearchTextField.becomeFirstResponder();
        
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.user.token = tokenIsValid
            print("Mytoken: "+self.user.token)
        }else {
            print("aucun token");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //lorsque le user clique sur ajouter
    @IBAction func addFriend(_ sender: Any) {
        let emailFriend = EmailFriendTextField.text;
        
        //verif champs vide
        if((emailFriend?.isEmpty)!){
            displayMessage(myTitle: "Attention", userMessage: "Veuillez renseigner l'amis que vous voulez ajouter");
            return;
        }
        //Si les champs ne sont pas vide, alors appel methode ajouter amis
        let userDict = ["token": self.user.token, "mail": emailFriend!] as [String: AnyObject]
        let stringUrl = env+self.addFriendURL
        print("addFriend")
        print(stringUrl)
        self.user.sendRequest(url: stringUrl, userDict: userDict) { (response) in
            DispatchQueue.main.async {
                if(response == "200"){
                    self.displayMessage(myTitle: "Félicitations", userMessage: "Demande d'amis envoyée");
                    return;
                } else if(response == "401"){
                    self.displayMessage(myTitle: "Désolé", userMessage: "Cette personne n'existe pas");
                    return;
                } else if(response == "403"){
                    self.displayMessage(myTitle: "Désolé", userMessage: "Cette personne fait deja partie de vos amis");
                    return;
                } else {
                    self.displayMessage(myTitle: "Oups", userMessage: "Une erreur est survenue");
                    return;
                }
            }
        }
        
    }
    /*
     DispatchQueue.main.async {
     if(myData == "200"){
     self.displayMessage(myTitle: "Félicitations", userMessage: "Demande d'amis envoyée");
     return;
     } else if(myData == "400"){
     self.displayMessage(myTitle: "Désolé", userMessage: "Cette personne n'existe pas");
     return;
     }
     }
     */
    
    //message info
    func displayMessage(myTitle: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: myTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
