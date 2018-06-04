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
    
    // API paths
    @IBInspectable var resetPasswordURL: String!
    
    // API URL
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Local variables
    private var user = User()
    
    @IBAction func resetPassword(_ sender: Any) {
        let userEmail = userEmailTextField.text;
        // Field empty
        if((userEmail?.isEmpty)!){
            displayMessage(header: "Attention", userMessage: "Veuillez renseigner votre email pour continuer");
            return;
        }
        
        // If field not empty
        self.user.mail = userEmail!
        let stringUrl = env+self.resetPasswordURL
        self.user.resetPWD(url: stringUrl) { (response, data) in
            DispatchQueue.main.async {
                if(response == 200){
                    self.displayMessage(header: "Félicitation", userMessage: data);
                    return;
                } else {
                    self.displayMessage(header: "Attention", userMessage: data);
                    return;
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayMessage(header: String, userMessage: String)
    {
        let myAlert = UIAlertController(title: header, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
