//
//  Friend.swift
//  mapito
//
//  Created by m2sar on 18/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Friend: CustomStringConvertible {
    
    var mail : String;
    var prenom: String;
    var pos : CLLocationCoordinate2D;
    var lastpos : CLLocationCoordinate2D?;
    
    public var description: String { return "mail: \(mail), prenom: \(prenom), pos: \(pos)" }
    
    init(mail: String, prenom: String, latitude: Double, longitude: Double){
        self.mail = mail
        self.prenom = prenom
        self.pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
