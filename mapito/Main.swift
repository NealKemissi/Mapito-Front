//
//  Main.swift
//  mapito
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

// Decide wether MapController or ConnexionController is called

class MainController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard;
        let defaultValue = defaults.object(forKey: "token");
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        // If token -> map
        if defaultValue != nil{
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "profileView") as! UITabBarController;
            self.present(tabBarController, animated: false);
        }
            // If no token -> connexioncontroller
        else{
            let navigationController = storyboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController;
            //let navC = UINavigationController(rootViewController: connexionController)
            self.present(navigationController, animated: false);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
