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
    var token = ""
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
    
    //A utiliser ?
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

    
    func loginWithUsername(url: String, callback: @escaping (String, String)-> ()) {
        let userDict = ["mail": self.mail, "password": self.password] as [String: AnyObject]
        
        let baseUrl = URL(string: url)
        var request = URLRequest(url: baseUrl!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted) //remove opt
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
                    if(httpResponse.statusCode == 200){
                        print("data : ")
                        let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                        print(dataStringified ?? "Data could not be printed")
                        if let usableData = data {
                            do {
                                let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                                if let token = jsonArray as? [String: AnyObject] {
                                    self.token = (token["token"] as? String)!
                                    print(self.token)
                                }
                            } catch {
                                print("JSON serialisation failed")
                            }
                        }
                        callback("", self.token)
                        return;
                    } else if (httpResponse.statusCode == 403) {
                        callback("Le mot de passe est incorrect", "")
                        return;
                    } else {
                        callback("Problème inconnu", "")
                        return;
                    }
                }
            }
        }
        session.resume()
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
    
    func register(url: String, userDict: [String: AnyObject], callback: @escaping (String)-> ()){
        let baseUrl = URL(string: url)
        var request = URLRequest(url: baseUrl!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted) //remove opt
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
                    if(httpResponse.statusCode == 200){
                        callback("200")
                    } else if (httpResponse.statusCode == 403) {
                        callback("403")
                    } else {
                        callback("error")
                        return;
                    }
                }
            }
        }
        session.resume()
    }
    
    
    //modification de la valeur du user
    func updateUser(url : String, userDict: [String: AnyObject], callback: @escaping (String)-> ()){
        let baseUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: baseUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted) //remove opt
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
                    if(httpResponse.statusCode == 200){
                        callback("200")
                    } else if(httpResponse.statusCode == 403){
                        callback("403")
                    } else {
                        callback("error")
                    }
                }
            }}
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
    func sendRequest(url: String, userDict: [String: AnyObject], callback: @escaping (String)-> ()){
        let baseUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: baseUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted) //remove opt
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
                    if(httpResponse.statusCode == 200){
                        callback("200")
                    } else if(httpResponse.statusCode == 403){
                        callback("403")
                    } else if(httpResponse.statusCode == 401){
                        callback("401")
                    } else {
                        callback("error")
                    }
                }
            }}
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
    func resetPWD(url: String, userDict: [String: AnyObject], callback: @escaping (String)-> ()){
        let baseUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: baseUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted) //remove opt
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
                    if(httpResponse.statusCode == 200){
                        callback("OK")
                    } else {
                        callback("nOK")
                    }
                }
            }
        }
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
