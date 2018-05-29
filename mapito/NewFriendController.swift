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
    var Mytoken : String = "test"
    var friendResearchValue = ""
    @IBOutlet weak var friendResearchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendResearchTextField.text = self.friendResearchValue
        self.friendResearchTextField.becomeFirstResponder();
        
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
    
    //lorsque le user clique sur ajouter
    @IBAction func addFriend(_ sender: Any) {
        let emailFriend = EmailFriendTextField.text;
        
        //verif champs vide
        if((emailFriend?.isEmpty)!){
            displayMessage(myTitle: "Attention", userMessage: "Veuillez renseigner l'amis que vous voulez ajouter");
            return;
        }
        //Si les champs ne sont pas vide, alors appel methode ajouter amis
        let stringUrl = self.addFriendURL+"/"+self.Mytoken+"/"+emailFriend!
        let baseUrl = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // en param token field et value
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "PUT"
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let myData = String(data: data!, encoding: .utf8) {
                print(myData)
                DispatchQueue.main.async {
                    if(myData == "200"){
                        self.displayMessage(myTitle: "Félicitations", userMessage: "Demande d'amis envoyée");
                        return;
                    } else if(myData == "400"){
                        self.displayMessage(myTitle: "Désolé", userMessage: "Cette personne n'existe pas");
                        return;
                    }
                }
            }
            //si la valeur existe deja
        })
        session.resume()
    }
    
    //message info
    func displayMessage(myTitle: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: myTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
