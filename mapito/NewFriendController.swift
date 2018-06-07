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
    @IBOutlet weak var EmailFriendTextField: UITextField!
    @IBOutlet weak var friendResearchTextField: UITextField!
    
    // API paths
    @IBInspectable var addFriendURL: String!
    
    // API URL
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Local variables
    var friendResearchValue = ""
    private var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendResearchTextField.text = self.friendResearchValue
        self.friendResearchTextField.becomeFirstResponder();
        
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            self.user.token = tokenIsValid
            print("Mytoken: "+self.user.token)
        }else {
            print("aucun token");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addFriend(_ sender: Any) {
        let emailFriend = EmailFriendTextField.text;
        
        // Field empty
        if((emailFriend?.isEmpty)!){
            displayMessage(myTitle: "Attention", userMessage: "Veuillez renseigner l'amis que vous voulez ajouter");
            return;
        }
        // Field not empty
        let userDict = ["token": self.user.token, "mail": emailFriend!] as [String: AnyObject]
        let stringUrl = env+self.addFriendURL
        print("addFriend")
        print(stringUrl)
        self.user.sendFriendRequest(url: stringUrl, userDict: userDict) { (response, data) in
            DispatchQueue.main.async {
                if(response == 200){
                    self.displayMessage(myTitle: "Félicitations", userMessage: data);
                    return;
                } else {
                    self.displayMessage(myTitle: "Attention", userMessage: data);
                    return;
                }
            }
        }
        
    }
    
    func displayMessage(myTitle: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: myTitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
