//
//  Date.swift
//  mapito
//
//  Created by m2sar on 05/06/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation

class Date: CustomStringConvertible {
    
    var an: String = ""
    var mois: String = ""
    var jour: String = ""
    var heure: String = ""
    var minutes: String = ""
    var secondes: String = ""
    
    public var description: String { return "\(mois)/\(jour)/\(an)  (\(heure)h \(minutes)min \(secondes)s)" }
    // "\(mois)/\(jour)/\(an)  (\(heure):\(minutes):\(secondes))"
    /*
     "an: \(an), mois: \(mois), jour: \(jour), heure: \(heure), minutes: \(minutes), secondes: \(secondes)"
    */
    
    init?(json: [String: Any]) {
        self.an = (json["an"] as? String)!
        self.mois = (json["mois"] as? String)!
        self.jour = (json["jour"] as? String)!
        self.heure = (json["heure"] as? String)!
        self.minutes = (json["minutes"] as? String)!
        self.secondes = (json["secondes"] as? String)!
    }
}
