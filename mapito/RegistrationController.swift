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
    @IBOutlet weak var userPseudoTextField: UITextField!
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
        let userPseudo = userPseudoTextField.text;
        let userEmail = userEmailTextField.text;
        let userMdp = userMdpTextField.text;
        
        //verif champs vide
        if((userNom?.isEmpty)! || (userPrenom?.isEmpty)! || (userPseudo?.isEmpty)! || (userEmail?.isEmpty)! || (userMdp?.isEmpty)!){
            displayMessage(userMessage: "Veuillez remplir correctement tous les champs");
            return;
        }
        //Si les champs ne sont pas vide, alors appel methode d' inscription
        let baseUrl = URL(string: self.registerURL)!
        /*
         let query: [String : String] = [
         "nom" : userNom!,
         "prenom" : userPrenom!,
         "pseudo" : userPseudo!,
         "mail" : userEmail!,
         "password" : userMdp!
         ]*/
        let request = URLRequest(url: baseUrl)
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let jsonData = String(data: data!, encoding: .utf8) {
                print(jsonData)
            }
            //si l'email existe deja
        })
        session.resume()
    }
    
    //message info
    func displayMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Attention", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
