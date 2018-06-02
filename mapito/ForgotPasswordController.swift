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
    private var user = User()
    
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
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
        let userDict = ["mail": userEmail!] as [String: AnyObject]
        let stringUrl = env+self.resetPasswordURL+userEmail!
        self.user.resetPWD(url: stringUrl, userDict: userDict) { (response) in
            DispatchQueue.main.async {
                if(response == "200"){
                    self.displayMessage(header: "Mot de passe réinitialisé", userMessage: "Vous allez recevoir un email contenant votre nouveau mot de passe, consultez votre boîte mail");
                    return;
                } else {
                    self.displayMessage(header: "Désolé", userMessage: "Email incorrect");
                    return;
                }
            }
        }
    }
    
    //message info
    func displayMessage(header: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: header, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
