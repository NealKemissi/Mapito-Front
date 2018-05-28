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
    var Mytoken : String = "test"
    
    
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
            let stringUrl = self.loginURL+userEmail!+"/"+userMdp!
            let baseUrl = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! //pour ne pas avoir de probleme d'encodage
             let _: [String] = [
             userEmail!,
             userMdp!
             ]
            //let url = baseUrl.withQueries(query)!
            var url = URLRequest(url: baseUrl)
            url.httpMethod = "PUT"
            //let url = baseUrl //url en dur
            let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let jsonData = String(data: data!, encoding: .utf8) {
                    print(baseUrl)
                    self.Mytoken = jsonData
                    
                }
                DispatchQueue.main.async {
                    self.loginActionFinished();
                }
                /*
                 let feed = (try? JSONSerialization.jsonObject(with:
                 jsonData , options: .mutableContainers)) as? NSDictionary ,
                 let nom = feed.value(forKeyPath: "feed.entry.im:nom.label") as? String ,
                 let prenom = feed.value(forKeyPath: "feed.entry.im:prenom.label") as? String ,
                 let mail = feed.value(forKeyPath: "feed.entry.im:mail.label") as? String ,
                 let password = feed.value(forKeyPath: "feed.entry.im:password.label") as? String ,
                 let friends = feed.value(forKeyPath: "feed.entry.im:friends.label") as? [Friend] {
                 let MyUser = User(nom: nom, prenom: prenom, mail: mail, password: password, friends: friends)
                 self.loginActionFinished();
                 //self.titleLabel.text = title; self.artistLabel.text = artist
                 }*/
                //si l'email et le mdp ne sont incorrect (si jsonData = null)
            }
                session.resume()
            
            //loginActionFinished();
        
        
        /*
         * Si non alors l'utilisateur se connecte
         */
        //user.loginWithUsername(username: userEmail!, password: userMdp!);
        
        /*NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue:"loginActionFinished"),
            object: nil,
            queue: nil,
            using: loginActionFinished(notification:))*/
        //loginActionFinished();
        
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
        print("Mytoken : "+self.Mytoken)
        let tokenRetrieved = self.Mytoken; //"test"
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
