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
    var numTel : String = "";
    var friends: [Friend] = [];
    var appNotifications: [AppNotification] = []
    var token = ""
    var latitude: String = ""
    var longitude: String = ""
    
    init(nom: String, prenom: String, mail: String, password: String){
        self.nom = nom;
        self.prenom = prenom;
        self.mail = mail;
        self.password = password;
    }
    
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

    
    func loginWithUsername(url: String, callback: @escaping (Int, String)-> ()) {
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
                    let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                    if(httpResponse.statusCode == 200){
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
                        callback(200, self.token)
                        return;
                    } else if (httpResponse.statusCode == 403) {
                        callback(403, dataStringified!)
                        return;
                    } else if (httpResponse.statusCode == 404) {
                        callback(404, dataStringified!)
                        return;
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                        return;
                    }
                }
            }
        }
        session.resume()
    }
    
    func register(url: String, callback: @escaping (Int, String)-> ()){
        let userDict = ["mail": self.mail, "password": self.password, "nom": self.nom, "prenom": self.prenom] as [String: AnyObject]
        
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
                    let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if (httpResponse.statusCode == 403) {
                        callback(403, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                        return;
                    }
                }
            }
        }
        session.resume()
    }
    
    func getFriends(url: String, callback: @escaping (Int, [Friend])-> ()){
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.addValue(self.token, forHTTPHeaderField: "Authorization")

        let session = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let usableData = data {
                if let httpResponse = response as? HTTPURLResponse {
                    if(httpResponse.statusCode == 200){
                        do {
                            let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                            if let friendsJSON = jsonArray as? [[String: AnyObject]] {
                                self.friends = friendsJSON.map { Friend(json: $0) }
                                print(self.friends)
                            }
                        } catch {
                            print("JSON serialisation failed")
                        }
                        callback(200, self.friends)
                    } else if (httpResponse.statusCode == 404) {
                        callback(404, [])
                    } else {
                        callback(httpResponse.statusCode, [])
                        return;
                    }
                }
            }
        }
        session.resume()
    }
    
    //send my contact number and return the potential friends
    func getPotentialFriends(url: String, listContact : String, callback: @escaping (Int, [Friend])-> ()){
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.addValue(listContact, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let usableData = data {
                if let httpResponse = response as? HTTPURLResponse {
                    if(httpResponse.statusCode == 200){
                        let dataStringified = String(data: usableData, encoding: String.Encoding.utf8)
                        print(dataStringified!)
                        do {
                            let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                            if let friendsJSON = jsonArray as? [[String: AnyObject]] {
                                self.friends = friendsJSON.map { Friend(json: $0) }
                                print(self.friends)
                            }
                        } catch {
                            print("JSON serialisation failed of failed")
                        }
                        callback(200, self.friends)
                    } else if (httpResponse.statusCode == 404) {
                        callback(404, [])
                    } else {
                        callback(httpResponse.statusCode, [])
                        return;
                    }
                }
            }
        }
        session.resume()
    }
    
    
    // Get one value of user's attribute (email, name, firstname, password)
    // Pas opérationnel ?
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
    
    
    // Update one field of user (email, name, firstname, password)
    func updateUser(url : String, userDict: [String: AnyObject], callback: @escaping (Int, String)-> ()){
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
                let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                if let httpResponse = response as? HTTPURLResponse {
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if(httpResponse.statusCode == 403){
                        callback(403, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                    }
                }
            }
        }
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
    
    func getAppNotifications(url: String, callback: @escaping ([AppNotification])-> ()){
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.addValue(self.token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let usableData = data {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers)
                    if let notificationsJSON = jsonArray as? [[String: AnyObject]] {
                        self.appNotifications = notificationsJSON.map { AppNotification(json: $0)! }
                    }
                    callback(self.appNotifications)
                } catch {
                    print("JSON serialisation failed")
                }
            }
        }
        session.resume()
    }
    
    func sendFriendRequest(url: String, userDict: [String: AnyObject], callback: @escaping (Int, String)-> ()){
        let baseUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: baseUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted)
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
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if(httpResponse.statusCode == 403){
                        callback(403, dataStringified!)
                    } else if(httpResponse.statusCode == 404){
                        callback(404, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                    }
                }
            }
        }
        session.resume()
    }
    
    func acceptFriendRequest(url : String, userDict: [String: AnyObject], callback: @escaping (Int, String)-> ()){
        //Put dictionary here
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
                    let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if(httpResponse.statusCode == 403){
                        callback(403, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                    }
                }
            }
        }
        session.resume()
    }
    
    func denyFriendRequest(url : String, userDict: [String: AnyObject], callback: @escaping (Int, String)-> ()){
        // Put dictionary here
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
                    let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if(httpResponse.statusCode == 404){
                        callback(404, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, dataStringified!)
                    }
                }
            }
        }
        session.resume()
    }
    
    func deleteFriend(url: String, emailFriend: String, callback: @escaping (Int, String)-> ()) {
        let userDict = ["token": self.token, "mail": emailFriend] as [String: AnyObject]
        
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        do {
            let bodyJSON = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted)
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
                     print(dataStringified ?? "Data could not be printed")
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if(httpResponse.statusCode == 404){
                        callback(404, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                    }
                }
            }
        }
        session.resume()
    }
    
    
    func resetPWD(url: String, callback: @escaping (Int, String)-> ()){
        let userDict = ["mail": self.mail] as [String: AnyObject]
        
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
                    let dataStringified = String(data: data!, encoding: String.Encoding.utf8)
                    if(httpResponse.statusCode == 200){
                        callback(200, dataStringified!)
                    } else if(httpResponse.statusCode == 404){
                        callback(404, dataStringified!)
                    } else {
                        callback(httpResponse.statusCode, "Une erreur est survenue")
                    }
                }
            }
        }
        session.resume()
    }
    
    func updatePosition(url: String, callback: @escaping (Int)-> ()){
        let userDict = ["token": self.token, "lon": self.longitude, "lat": self.latitude] as [String: AnyObject]
        
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
                        callback(200)
                    } else {
                        callback(httpResponse.statusCode)
                    }
                }
            }
        }
        session.resume()
    }
}
