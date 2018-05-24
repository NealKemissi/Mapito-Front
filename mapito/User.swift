//
//  User.swift
//  mapito
//
//  Created by m2sar on 21/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class User {
    
    
    /*var nom : String;
    var prenom : String;
    var mail : String;
    var password : String;
    var friends : [Friend];
    var pos : MKUserLocation;*/
    
    /*init(nom: String, prenom: String, mail: String, password: String, friends: [Friend]){
        self.nom = nom;
        self.prenom = prenom;
        self.mail = mail;
        self.password = password;
        self.friends = friends;
        self.pos = MKUserLocation() ;
    }*/    
    
    func loginWithUsername(username : String, password : String) {
        //Valide le user et notifie root controller
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "loginActionFinished"),
            object: self,
            userInfo: nil)
    }
    
    func register(nom: String, prenom: String, pseudo:String, mail: String, password: String) {
        
    }
    
    func logout() {
        //Delete the account
    }
    
    func userAuthenticated() -> Bool{
        let auth : Bool = true;
        
        return auth;
    }
    
    func getFriends(url: String) -> [Friend]{
        var friend: Friend?
        var friends: [Friend]? = []
        let dataTemplate = "[" +
            "{\n" +
            "\"id\":1,\n" +
            "\"latitude\":48.851164,\n" +
            "\"longitude\":2.348156,\n" +
            "},\n" +
            "{\n" +
            "\"id\":2,\n" +
            "\"latitude\":48.850164,\n" +
            "\"longitude\":2.349156,\n" +
            "}\n" +
        "]"
        let data = dataTemplate.data(using: .utf8)
        /*
         [
         {
         "id": 1,
         "latitude": 48.851164,
         "longitude": 2.348156,
         },
         {
         "id": 2,
         "latitude": 48.850164,
         "longitude": 2.349156,
         }
         ]
         */
        
        //HTTP Request, penser à passer le token en paramètres
        /*let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared.dataTask(with: request ,completionHandler:
        { (data, response, error) in
            if let usableData = data{
                let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary,
                let id = feed.value(forKeyPath: "id") as? String,
                let latitude = feed.value(forKeyPath: "latitude") as? String ,
                let longitude = feed.value(forKeyPath: "longitude") as? String {
                    //Stocker ami dans [Friend]
                }
            }
        })
        session.resume()*/
        print("data : ")
        let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
        print(dataStringified ?? "Data could not be printed")
        if let usableData = data {
            var id : Int = 0
            var latitude : Double = 0
            var longitude : Double = 0
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                if let friendsJSON = jsonArray as? [[String: AnyObject]] {
                    for index in 0..<friendsJSON.count {
                        //let id = parseJSONArray[0]["id"] as? String
                        id = (friendsJSON[index]["id"] as? Int)!
                        latitude = (friendsJSON[index]["latitude"] as? Double)!
                        longitude = (friendsJSON[index]["longitude"] as? Double)!
                        friend = Friend(id: id, latitude: latitude, longitude: longitude)
                        print(id)
                        print(latitude)
                        print(longitude)
                        print("friend")
                        print(friend!)
                        friends?.append(friend!)
                    }
                }
            } catch {
                print("JSON serialisation failed")
            }
        }        
        return friends!
    }
}
