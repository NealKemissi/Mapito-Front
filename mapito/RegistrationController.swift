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
    
    // les textes fields
    @IBOutlet weak var userNomTextField: UITextField!
    @IBOutlet weak var userPrenomTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userMdpTextField: UITextField!
    //path de la methode d'inscription
    @IBInspectable var registerURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //lors du clique pour l'inscription
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
        //Si les champs ne sont pas vide, alors appel methode d' inscription
        let stringUrl = self.registerURL+userEmail!+"/"+userMdp!+"/"+userNom!+"/"+userPrenom!
        let baseUrl = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
         let query: [String : String] = [
            "nom" : userNom!,
            "prenom" : userPrenom!,
            "mail" : userEmail!,
            "password" : userMdp!
         
         ]
        var request = URLRequest(url: baseUrl!)
        //let request = baseUrl.withQueries(query)
        request.httpMethod = "POST"
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            let responseString = String(data : data, encoding: .utf8)
            DispatchQueue.main.async {
                if(responseString == "500"){
                    self.displayMessage(Mytitle: "Attention", userMessage: "Cet email existe deja, Veuillez recommencer");
                    return;
                } else {
                    self.displayMessage(Mytitle: "Félicitations", userMessage: "Bienvenue sur Mapito, vous pouvez maintenant vous connecter");
                    return;
                }
            }
            print("reponse = \(responseString)")
            //si l'email existe deja
        }
        session.resume()
    }
    
    //message info
    func displayMessage(Mytitle: String ,userMessage: String)
    {
        let myAlert = UIAlertController(title: Mytitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
