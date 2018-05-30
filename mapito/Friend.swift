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
    
    var mail : String = ""
    var prenom: String = ""
    var inTheArea:  Bool = false
    //var lastInTheArea: Bool = false
    var pos : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var lastpos : CLLocationCoordinate2D? = CLLocationCoordinate2D()    
    
    public var description: String { return "mail: \(mail), prenom: \(prenom), pos: \(pos)" }
    
    init(json: [String: Any]) {
        self.mail = (json["mail"] as? String)!
        self.prenom = (json["prenom"] as? String)!
        self.inTheArea = (json["inTheArea"] as? Bool)!
        //self.lastInTheArea = (json["lastInTheArea"] as? Bool)!
        let latitude = (json["latitude"] as? Double)!
        let longitude = (json["longitude"] as? Double)!
        let lastLatitude = (json["lastlatitude"] as? Double)!
        let lastLongitude = (json["lastlongitude"] as? Double)!
        self.pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.lastpos = CLLocationCoordinate2D(latitude: lastLatitude, longitude: lastLongitude)
    }
    
    init(mail: String, prenom: String, latitude: Double, longitude: Double){
        self.mail = mail
        self.prenom = prenom
        self.pos = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func sendProxNotif(url: String){
        let baseUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // en param token field et value
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "PUT"
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let myData = String(data: data!, encoding: .utf8) {
                print(myData)
            }
        })
        session.resume()
    }
}
