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
    var date: Date?
    
    public var description: String { return "type: \(type ?? -1), message: \(message), mail: \(mail), date: \(date))" }
    
    init?(json: [String: Any]) {
        self.type = json["type"] as? Int
        self.message = json["message"] as! String
        self.mail = json["mail"] as! String
        if let date = json["date"] as? [String: Any] {
            self.date = Date(json: json["date"] as! [String : Any])
        }
    }
}
