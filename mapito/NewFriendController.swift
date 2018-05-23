//
//  NewFriendController.swift
//  mapito
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class NewFriendController: UIViewController {
    
    @IBOutlet weak var NomFriendTextField: UITextField!
    @IBOutlet weak var PrenomFriendTextField: UITextField!
    //path de la methode modification ajout amis
    @IBInspectable var addFriendURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //lorsque le user clique sur ajouter
    @IBAction func addFriend(_ sender: Any) {
        let nomFriend = NomFriendTextField.text;
        let prenomFriend = PrenomFriendTextField.text;
        
        //verif champs vide
        if((nomFriend?.isEmpty)! || (prenomFriend?.isEmpty)!){
            displayMessage(userMessage: "Veuillez remplir correctement tous les champs");
            return;
        }
        //Si les champs ne sont pas vide, alors appel methode ajouter amis
        let baseUrl = URL(string: self.addFriendURL)!
        /*
         let query: [String : String] = [
         "nomFriend" : nomFriend!,
         "prenomFriend" : prenomFriend!
         ]*/
        let request = URLRequest(url: baseUrl)
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let jsonData = String(data: data!, encoding: .utf8) {
                print(jsonData)
            }
            //si l'amis existe pas deja
        })
        session.resume()
    }
    
    //message info
    func displayMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title: "Attention", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
