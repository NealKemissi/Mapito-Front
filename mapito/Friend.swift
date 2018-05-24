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
    
    var id : Int;
    var pos : CLLocationCoordinate2D;
    var lastpos : CLLocationCoordinate2D?;
    
    public var description: String { return "id: \(id), pos: \(pos)" }
    
    init(id: Int, latitude: Double, longitude: Double){
        self.id = id
        self.pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func setLastpos(pos: CLLocationCoordinate2D){
        self.lastpos = pos
        //Actualiser dans le back
    }
}
