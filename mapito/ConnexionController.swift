//
//  ConnexionController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class ConnexionController : UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userMdpTextField: UITextField!
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let userEmail = userEmailTextField.text;
        let userMdp = userMdpTextField.text;
        
        //verif champs vide
        if((userEmail?.isEmpty)! || (userMdp?.isEmpty)!){
            displayMessage(userMessage: "Veuillez remplir correctement tout les champs");
            return;
        }
        /*
         * Si les champs ne sont pas vide, alors
         * verif si l'email et le mdp ne sont pas incorrect
         */
        
        /*
         * Si non alors l'utilisateur se connecte
         */
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue:"loginActionFinished"),
            object: nil,
            queue: nil,
            using: loginActionFinished(notification:))
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginActionFinished(notification: Notification) -> Void{
            print("Catch notification")
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
