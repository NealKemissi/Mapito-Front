//
//  ForgotPasswordController.swift
//  mapito
//
//  Created by m2sar on 23/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    //path de la methode reset password
    @IBInspectable var resetPasswordURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func resetPassword(_ sender: Any) {
        
        let userEmail = userEmailTextField.text;
        //verif champs vide
        if((userEmail?.isEmpty)!){
            displayMessage(header: "Attention", userMessage: "Veuillez renseigner votre email pour continuer");
            return;
        }
        //Si email renseigné alors appel de la methode reset password du mot de passe
        let baseUrl = URL(string: self.resetPasswordURL)!
        /*
         let query: [String : String] = [
         "mail" : userEmail!
         ]*/
        let request = URLRequest(url: baseUrl)
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let jsonData = String(data: data!, encoding: .utf8) {
                print(jsonData)
            }
        })
        session.resume()
        displayMessage(header: "Mot de passe réinitialisé", userMessage: "Vous allez recevoir un email contenant votre nouveaux mot de passe, consultez votre boite mail");
        //retour a la page d'accueil (connexion)
       
    }
    
    //message info
    func displayMessage(header: String, userMessage: String)
    {
        var myAlert = UIAlertController(title: header, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
