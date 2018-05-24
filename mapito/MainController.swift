//
//  Main.swift
//  mapito
//
//  Created by m2sar on 16/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

// Decide whether MapController or LoginController is called

class MainController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard;
        let defaultValue = defaults.object(forKey: "token");
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        // If token -> MainTabBar
        if defaultValue != nil{
            let mainTabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController;
            self.present(mainTabBar, animated: false);
        }
        // If no token -> NavigationAuthentication
        else{
            let navigationAuthentication = storyboard.instantiateViewController(withIdentifier: "NavigationAuthentication") as! UINavigationController;
            //let navC = UINavigationController(rootViewController: LoginController)
            self.present(navigationAuthentication, animated: false);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
