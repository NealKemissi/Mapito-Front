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
    
    
    var nom : String = "";
    var prenom : String = "";
    var mail : String = "";
    var password : String = "";
    var friends : [Friend] = [];
    //var pos : MKUserLocation;
    
    /*init(nom: String, prenom: String, mail: String, password: String, friends: [Friend]){
        self.nom = nom;
        self.prenom = prenom;
        self.mail = mail;
        self.password = password;
        self.friends = friends;
        self.pos = MKUserLocation() ;
    }*/
    
    init(){
    }
    
    //A utiliser
    init?(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let body = json["data"] as? [String: Any] {
                    self.nom = (body["nom"] as? String)!
                    self.prenom = (body["prenom"] as? String)!
                    self.mail = (body["mail"] as? String)!
                }
        } catch {
            print("Error deserializing JSON: \(error)")
            return nil
        }
    }

    
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
    
    func getFriends(url: String, callback: @escaping ([Friend])-> ()){
        var friend: Friend?
        var friends: [Friend] = []
        let dataTemplate = "[" +
            "{\n" +
            "\"email\":neal.k@hotmail.fr,\n" +
            "\"latitude\":48.851164,\n" +
            "\"longitude\":2.348156,\n" +
            "},\n" +
            "{\n" +
            "\"email\":ch@gmail.com,\n" +
            "\"latitude\":48.850164,\n" +
            "\"longitude\":2.349156,\n" +
            "}\n" +
        "]"
        let data = dataTemplate.data(using: .utf8)
        /*
         [
         {
         "id": ch,
         "latitude": 48.851164,
         "longitude": 2.348156,
         },
         {
         "id": gen3, poet,
         "latitude": 48.850164,
         "longitude": 2.349156,
         }
         ]
         */
        
        //HTTP Request, penser à passer le token en paramètres
        let request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        let session = URLSession.shared.dataTask(with: request ,completionHandler:
        { (data, response, error) in
            print("data : ")
            let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
            print(dataStringified ?? "Data could not be printed")
            if let usableData = data {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                    if let friendsJSON = jsonArray as? [[String: AnyObject]] {
                        //A tester ci-dessous
                        friends = friendsJSON.map { Friend(json: $0) }
                        print(friends)
                    }
                    callback(friends)
                } catch {
                    print("JSON serialisation failed")
                }
            }
        })
        session.resume()
    }
}
