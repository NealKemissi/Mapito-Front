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
    //path de la methode modification attributs
    var myValue : String?
    @IBInspectable var modifURL: String!
    @IBInspectable var userFieldURL: String! //recuperation de l'attribut du user (ex: recup mail ou recup prenom etc..)
    //var Mytoken : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //affichage de la valeur actuelle
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            let Mytoken = tokenIsValid
            let stringUrl = self.userFieldURL!+"/"+Mytoken
            let baseUrl = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // trouver comment faire pour envoyer le field (qui differe selon chaque page)
            let request = URLRequest(url: baseUrl)
            let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
                if let myData = String(data: data!, encoding: .utf8) {
                    print(myData)
                    self.myValue = myData
                    print("Mytoken: "+Mytoken)
                }
            })
            session.resume()
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
        }
        //Si les champs ne sont pas vide, alors appel methode d' inscription
        let stringUrl = self.modifURL+"/"+confirm!
        let baseUrl = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // en param token field et value
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "PUT"
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let jsonData = String(data: data!, encoding: .utf8) {
                print(jsonData)
                DispatchQueue.main.async {
                    if(jsonData == "200"){
                        self.displayMessage(Mytitle: "Félicitations", userMessage: "Vous avez changer votre profil");
                        return;
                    }
            }
        }
        //si la valeur existe deja
        })
        session.resume()
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
