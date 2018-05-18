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

class Friend {
    
    var id : Int;
    var pos : CLLocation;
    
    init(id: Int, latitude: Double, longitude: Double){
        self.id = id;
        self.pos = CLLocation(latitude: latitude, longitude: longitude);
    }
}
