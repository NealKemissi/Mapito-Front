//
//  Notification.swift
//  mapito
//
//  Created by m2sar on 30/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation

class AppNotification: CustomStringConvertible {
    
    var message: String = ""
    
    public var description: String { return "message: \(message)" }
    
    init?(json: [String: Any]) {
        self.message = (json["message"] as? String)!
    }
}
