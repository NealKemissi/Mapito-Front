//
//  ControllerHelper.swift
//  mapito
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard{
    enum Identifier: String {
        case NavigationAuthentication = "NavigationAuthentication"
        case LoginController = "initialView"
        case MainTabBar = "MainTabBar"
    }
    
    func instantiateViewControllerWithIdentifier(identifier:Identifier) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
}
