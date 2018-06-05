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
    var lastInTheArea: Bool = false
    var pos : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var lastpos : CLLocationCoordinate2D? = CLLocationCoordinate2D()    
    
    public var description: String { return "mail: \(mail), prenom: \(prenom), pos: \(pos)" }
    
    init(json: [String: Any]) {
        self.mail = (json["mail"] as? String)!
        self.prenom = (json["prenom"] as? String)!
        self.inTheArea = (json["inTheArea"] as? Bool)!
        self.lastInTheArea = (json["lastInTheArea"] as? Bool)!
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
    
    func sendProxNotif(url: String, token: String, contenu: String, callback: @escaping (Int, String)-> ()){
        let friendDict = ["token": token, "mail": self.mail, "contenu": contenu] as [String: String]
        
        let baseUrl = URL(string: url)
        var request = URLRequest(url: baseUrl!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: friendDict, options: .prettyPrinted)
            let bodyJSONStringified = String(data: bodyJSON, encoding: String.Encoding.utf8)
            print(bodyJSONStringified!)
            request.httpBody = bodyJSON
        } catch let error {
            print(error.localizedDescription)
        }
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                    print("SendProxNotif data")
                    print(dataStringified!)
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if (httpResponse.statusCode == 404) {
                        callback(404, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                        return;
                    }
                }
            }
        }
        session.resume()
    }
}
