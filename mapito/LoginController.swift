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
    var Mytoken : String = "leToken"
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
            let jsonString = ["mail": userEmail!,
                            "password": userMdp!
                                                    ]
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonString)
            let stringUrl = env+self.loginURL!
            let baseUrl = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            //let url = baseUrl.withQueries(query)!
            var url = URLRequest(url: baseUrl)
            url.httpMethod = "PUT"
            url.httpBody = jsonData
            //let url = baseUrl //url en dur
            let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let myData = data {
                    print(String(data: jsonData!, encoding: .utf8))
                    do {
                        print("--------------------myTest--------------------------")
                        print(String(data: myData, encoding: .utf8))
                        let jsonArray = try JSONSerialization.jsonObject(with: myData, options: .mutableContainers) as? [String:AnyObject]
                        print("--------------------myTest--------------------------")
                        //print(jsonArray)
                        if let tokenJSON = jsonArray {
                            print(String(describing: tokenJSON))
                            //self.Mytoken = String(describing: tokenJSON)
                        }
                    } catch {
                        print("JSON serialisation failed")
                    }
                    //print(baseUrl)
                    //self.Mytoken = myData
                    
                }
                DispatchQueue.main.async {
                    self.loginActionFinished();
                }
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
