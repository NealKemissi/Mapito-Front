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
    //path de la methode d'authentification
    @IBInspectable var loginURL: String!
    let user = User()
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let userEmail = self.userEmailTextField.text;
        let userMdp = self.userMdpTextField.text;
        //let user = User();
        
        //verif champs vide
        if((userEmail?.isEmpty)! || (userMdp?.isEmpty)!){
            displayMessage(userMessage: "Veuillez remplir correctement tous les champs");
            return;
        }
        //Si les champs ne sont pas vide, alors appel methode d'authentification
        let url = env+self.loginURL!
        user.mail = userEmail!
        user.password = userMdp!
        user.loginWithUsername(url: url, callback: { (message, token) in
            if(message != ""){
                self.displayMessage(userMessage: message)
            }
<<<<<<< HEAD
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if(httpResponse.statusCode == 200){
                        self.Mytoken = String(data: data!, encoding: String.Encoding.utf8)!
                        self.loginActionFinished();
                        return;
                    } else if (httpResponse.statusCode == 403) {
                        self.displayMessage(userMessage: "Le mot de passe ou l'identifiant ne sont pas corrects (à vérifier avec le back)");
                        return;
                    } else {
                        self.displayMessage(userMessage: "Problème inconnu");
                        return;
                    }
                }
            }
        }
        session.resume()        
=======
            self.user.token = token
            self.loginActionFinished()
        })
>>>>>>> 108bb5e53d81e8c9d93f35b7ed0c8e77d3e2709a
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //recuperer le token et passer a l'autre page
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
    
    //message info
    func displayMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Attention", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
    // methode pour se rendre sur le controller du profil du user lorsque celui ci s'est connecter
    func dismissLoginAndShowProfile() {
        let mainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let mainTabBar = mainStory.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController;
        self.present(mainTabBar, animated: true);
    }

}
//extension de la classe URL pour pouvoir utiliser les queries
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        return components?.url
    }
}
