//
//  DetailedProfileController.swift
//  mapito
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class DetailedProfileController: UIViewController {
    
    
    @IBOutlet weak var newValueTextField: UITextField!
    @IBOutlet weak var confirmNewValueTextField: UITextField!
    //path de la methode modification attributs
    @IBInspectable var modifURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //lorsque le user clique sur modifier
    @IBAction func modificationValue(_ sender: Any) {
        let newValue = newValueTextField.text;
        let confirm = confirmNewValueTextField.text;
        
        //verif champs vide
        if((newValue?.isEmpty)! || (confirm?.isEmpty)!){
            displayMessage(userMessage: "Veuillez remplir correctement tous les champs");
            return;
        }
        //Si les champs ne sont pas vide, alors appel methode d' inscription
        let baseUrl = URL(string: self.modifURL)!
        /*
         let query: [String : String] = [
         "newValue" : newValue!,
         "confirm" : confirm!
         ]*/
        let request = URLRequest(url: baseUrl)
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let jsonData = String(data: data!, encoding: .utf8) {
                print(jsonData)
            }
            //si la valeur existe deja
        })
        session.resume()
    }
    
    //message info
    func displayMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Attention", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}
