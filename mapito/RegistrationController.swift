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
    
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
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
        //To do in user model
        let userDict = ["mail": userEmail, "password": userMdp, "nom": userNom, "prenom": userPrenom] as [String: AnyObject]
        
        let stringUrl = env + self.registerURL
        let baseUrl = URL(string: stringUrl)
        var request = URLRequest(url: baseUrl!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted) //remove opt
            let bodyJSONStringified = String(data: bodyJSON, encoding: String.Encoding.utf8)
            print(bodyJSONStringified!)
            request.httpBody = bodyJSON
        } catch let error {
            print(error.localizedDescription)
        }
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if(httpResponse.statusCode == 200){
                        self.displayMessage(Mytitle: "Félicitations", userMessage: "Bienvenue sur Mapito, vous pouvez maintenant vous connecter");
                        return;
                    } else if (httpResponse.statusCode == 403) {
                        self.displayMessage(Mytitle: "Attention", userMessage: "Cet email existe déjà, veuillez recommencer");
                        return;
                    } else {
                        self.displayMessage(Mytitle: "Attention", userMessage: "Problème inconnu");
                        return;
                    }
                }
            }
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
