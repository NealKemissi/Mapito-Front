//
//  InscriptionController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class InscriptionController : UIViewController {
    
    // les textes fields
    @IBOutlet weak var userNomTextField: UITextField!
    @IBOutlet weak var userPrenomTextField: UITextField!
    @IBOutlet weak var userPseudoTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userMdpTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //lors du clique pour l'inscription
    @IBAction func inscriptionButtonAction(_ sender: Any) {
        
        let userNom = userNomTextField.text;
        let userPrenom = userPrenomTextField.text;
        let userPseudo = userPseudoTextField.text;
        let userEmail = userEmailTextField.text;
        let userMdp = userMdpTextField.text;
        
        //verif champs vide
        if((userNom?.isEmpty)! || (userPrenom?.isEmpty)! || (userPseudo?.isEmpty)! || (userEmail?.isEmpty)! || (userMdp?.isEmpty)!){
            displayMessage(userMessage: "Veuillez remplir correctement tout les champs");
            return;
        }
        /*
         *
         *
         * Si les champs ne sont pas vide, alors
         * verif si le nom ou pseudo existe deja dans la bdd
         *
         *
        */
        
        /*
         *
         * Si non alors l'utilisateur creer son compte
         *
         */
        
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
