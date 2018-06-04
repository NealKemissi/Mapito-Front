//
//  Notification.swift
//  mapito
//
//  Created by m2sar on 30/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation

class AppNotification: CustomStringConvertible {
    
    var mail: String = ""
    var message: String = ""
    var type: Int?
    
    public var description: String { return "mail: \(mail)" }
    
    init?(json: [String: Any]) {
        self.type = (json["type"] as? Int)!
        self.message = (json["message"] as? String)!
        self.mail = (json["mail"] as? String)!
    }
}
