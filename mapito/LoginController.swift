//
//  LoginController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class LoginController : UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userMdpTextField: UITextField!
    
    // API paths
    @IBInspectable var loginURL: String!
    
    // API URL
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Local variables
    let user = User()    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let userEmail = self.userEmailTextField.text;
        let userMdp = self.userMdpTextField.text;
        
        // Fields empty
        if((userEmail?.isEmpty)! || (userMdp?.isEmpty)!){
            displayMessage(userMessage: "Veuillez remplir correctement tous les champs");
            return;
        }
        
        // If fields not empty
        let url = env+self.loginURL!
        user.mail = userEmail!
        user.password = userMdp!
        user.loginWithUsername(url: url, callback: { (response, data) in
            if(response == 200){
                self.user.token = data
                self.loginActionFinished()
                return
            }
            self.displayMessage(userMessage: data)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Retrieve token and change page
    func loginActionFinished() -> Void{
        print("Mytoken : "+self.user.token)
        let tokenRetrieved = self.user.token; //"test"
        if(tokenRetrieved == ""){
            displayMessage(userMessage: "Email ou mot de passe incorrect");
            return;
        }
        dismissLoginAndShowProfile();
        let defaults = UserDefaults.standard;
        defaults.set(tokenRetrieved, forKey: "token");
        defaults.synchronize();
    }
    
    // Go to ProfileController when user connected successfully
    func dismissLoginAndShowProfile() {
        let mainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let mainTabBar = mainStory.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController;
        self.present(mainTabBar, animated: true);
    }
    
    func displayMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Attention", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
