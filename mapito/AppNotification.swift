//
//  Notification.swift
//  mapito
//
//  Created by m2sar on 30/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation

class AppNotification: CustomStringConvertible {
    
    var title : String = ""
    var message: String = ""
    
    public var description: String { return "title: \(title), description: \(message)" }
    
    init?(json: [String: Any]) {
        self.title = (json["titre"] as? String)!
        self.message = (json["message"] as? String)!
    }
}
