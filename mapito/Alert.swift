//
//  Alert.swift
//  mapito
//
//  Created by m2sar on 30/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation

class Alert: CustomStringConvertible {
    var title: String = ""
    var message: String = ""
    
    public var description: String { return "title: \(title), message: \(message)" }
    
    init(title: String, message: String){
        self.title = title
        self.message = message
    }
}
