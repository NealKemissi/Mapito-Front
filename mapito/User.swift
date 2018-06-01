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
    
    
    var nom: String = "";
    var prenom: String = "";
    var mail: String = "";
    var password: String = "";
    var valueField : String = "";
    var friends: [Friend] = [];
    var appNotifications: [AppNotification] = []
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
                        self.friends = friendsJSON.map { Friend(json: $0) }
                        print(self.friends)
                    }
                    callback(self.friends)
                } catch {
                    print("JSON serialisation failed")
                }
            }
        })
        session.resume()
    }
    
    //recup la valeur d'un attribut du user ex: recup mdp, nom, prenom
    func getFieldValue(url: String, callback: @escaping (String)-> ()){
        let request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        let session = URLSession.shared.dataTask(with: request ,completionHandler:
        { (data, response, error) in
            print("valueField : ")
            let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
            print(dataStringified ?? "Data could not be printed")
            if let usableData = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                    if let valueJSON = jsonData as? String {
                        self.valueField = valueJSON
                    }
                    callback(self.valueField)
                } catch {
                    print("JSON serialisation failed")
                }
            }
        })
        session.resume()
    }
    
    func getAppNotifications(url: String, callback: @escaping ([AppNotification])-> ()){
        let request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        let session = URLSession.shared.dataTask(with: request ,completionHandler:
        { (data, response, error) in
            print("data : ")
            let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
            print(dataStringified ?? "Data could not be printed")
            if let usableData = data {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                    if let notificationsJSON = jsonArray as? [[String: AnyObject]] {
                        self.appNotifications = notificationsJSON.map { AppNotification(json: $0)! }
                        print(self.appNotifications)
                    }
                    callback(self.appNotifications)
                } catch {
                    print("JSON serialisation failed")
                }
            }
        })
        session.resume()
    }
    
    //envoyer requete d'amis
    func sendRequest(url: String, callback: @escaping (String)-> ()){
        let baseUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "PUT"
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let myData = String(data: data!, encoding: .utf8) {
                print(myData)
                DispatchQueue.main.async {
                    if(myData == "200"){
                        print("request send ok")
                    } else if(myData == "400"){
                        print("request send notOK")
                    }
                    callback(myData)
                }
            }
        })
        session.resume()
        
    }
    
    //suppression d'ami
    func deleteFriend(url: String, callback: @escaping ([Friend])-> ()) {
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = "PUT"
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let myData = String(data: data!, encoding: .utf8) {
                print(myData)
                DispatchQueue.main.async {
                    if(myData == "200"){
                        print("user supprimé")
                    }
                callback(self.friends)
                }
            }
        })
        session.resume()
    }
    
    //recup les notifs pour la page notif (a completer)
    func getAllNotifs(url: String, callback: @escaping ([AppNotification])-> ()) {
        let request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let myData = String(data: data!, encoding: .utf8) {
                print(myData)
                callback(self.appNotifications)
            }
        })
        session.resume()
    }
    
    
    //resetPassword
    func resetPWD(url: String){
        let baseUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "PUT"
        let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
            if let myData = String(data: data!, encoding: .utf8) {
                print(myData)
            }
        })
        session.resume()
    }
    
    func updatePosition(url: String, callback: @escaping (String)-> ()){
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = "PUT"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print("updatePos : ")
            let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
            print(dataStringified ?? "Data could not be printed")
            if let usableData = dataStringified {
                print(usableData)
                callback(usableData)
            }
        })
        session.resume()
    }
}
