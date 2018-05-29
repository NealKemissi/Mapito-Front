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
    
    var mail : String = "";
    var prenom: String = "";
    var pos : CLLocationCoordinate2D = CLLocationCoordinate2D();
    var lastpos : CLLocationCoordinate2D? = CLLocationCoordinate2D();
    
    public var description: String { return "mail: \(mail), prenom: \(prenom), pos: \(pos)" }
    
    //A utiliser
    init(json: [String: Any]) {
        self.mail = (json["mail"] as? String)!
        self.prenom = (json["prenom"] as? String)!
        let latitude = (json["latitude"] as? Double)!
        let longitude = (json["longitude"] as? Double)!
        let lastLatitude = (json["lastLatitude"] as? Double)!
        let lastLongitude = (json["lastLongitude"] as? Double)!
        self.pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.lastpos = CLLocationCoordinate2D(latitude: lastLatitude, longitude: lastLongitude)
    }
    
    //Inutile ?
    init?(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let body = json["data"] as? [String: Any] {
                self.mail = (body["mail"] as? String)!
                self.prenom = (body["prenom"] as? String)!
                let latitude = (body["latitude"] as? Double)!
                let longitude = (body["longitude"] as? Double)!
                let lastLatitude = (body["lastLatitude"] as? Double)!
                let lastLongitude = (body["lastLongitude"] as? Double)!
                self.pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.lastpos = CLLocationCoordinate2D(latitude: lastLatitude, longitude: lastLongitude)
            }
        } catch {
            print("Error deserializing JSON: \(error)")
            return nil
        }
    }
    
    init(mail: String, prenom: String, latitude: Double, longitude: Double){
        self.mail = mail
        self.prenom = prenom
        self.pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
