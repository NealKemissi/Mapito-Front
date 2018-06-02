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
        //To do in user model
        let userDict = ["mail": userEmail!, "password": userMdp!] as [String: AnyObject]
        
        let stringUrl = env+self.loginURL!
        let baseUrl = URL(string: stringUrl)
        var request = URLRequest(url: baseUrl!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
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
