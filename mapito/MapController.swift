//
//  MapController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    // API paths
    @IBInspectable var myFriendsURL: String!
    @IBInspectable var sendProxNotifURL: String!
    @IBInspectable var getNotificationsURL: String!
    @IBInspectable var updatePosURL: String!
    
    // API url
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String

    var timer = Timer()
    var cpt: Double = 0.0
    let user = User()
    var Mytoken : String = ""
    let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
    let invisibleMode: Bool = false
    
    // Triggered when diplayed
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(setInvisibleMode), name: Notification.Name(rawValue: "switchStatus"), object: nil)
    }
    
    func setInvisibleMode(notification: Notification){
        print("setInvisibleMode")
        print(notification.object as Any)
        print(type(of: notification.object))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        mapView.setUserTrackingMode(.follow, animated: true)
        //Replace with method, singleton? Or put it in User --> See with teacher
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.Mytoken = tokenIsValid
            print("Mytoken: "+self.Mytoken)
        }else {
            print("No token found");
        }
        
        //scheduledTimerWithTimeInterval()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("---locations---")
        print(locations)
        let longitude = locations[0].coordinate.longitude
        let latitude = locations[0].coordinate.latitude
        print(longitude)
        print(latitude)
        let position = "/" + String(longitude) + "/" + String(latitude)
        let url = env + updatePosURL + self.Mytoken + position
        print(url)
        updateUserPos(url: url)
        updateFriendsPosition()
    }*/
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateFriendsPosition), userInfo: nil, repeats: true)
    }
    
    func updateFriendsPosition(){
        NSLog("refreshing position..")
        // Get friends of user -> call api/friends
        print("---test recupération friends---")
        let url = env + myFriendsURL + self.Mytoken
        print(url)
        user.getFriends(url: url, callback: { (friends) in
            print("---friends---")
            print(friends)
            if(friends.isEmpty==false){
                for friend in friends {
                    if (friend.lastpos != nil) {
                        print("--friend.lastpos--")
                        print(friend.lastpos!)
                        let lastPin = Pin(coordinate: friend.lastpos!)
                        self.mapView.removeAnnotation(lastPin)
                        self.mapView.removeAnnotation(lastPin)
                    }
                    //Faire enum
                    if(friend.inTheArea && friend.lastInTheArea == false){
                        let urlSendProxNotif = self.env + self.sendProxNotifURL + self.Mytoken + "/" + friend.mail + "/se trouve près de vous"
                        let urlGetNotifications = self.env + self.getNotificationsURL + self.Mytoken
                        friend.sendProxNotif(url: urlSendProxNotif)
                        self.user.getAppNotifications(url: urlGetNotifications, callback: { (appNotifications) in
                            print(appNotifications)
                            //Refresh Notification tab with notifications array
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapControllerRefresh"), object: appNotifications)
                        })
                    }
                    if(friend.inTheArea == false && friend.lastInTheArea == true){
                        let urlSendProxNotif = self.env + self.sendProxNotifURL + self.Mytoken + "/" + friend.mail + "/n'est plus près de vous"
                        let urlGetNotifications = self.env + self.getNotificationsURL + self.Mytoken
                        friend.sendProxNotif(url: urlSendProxNotif)
                        self.user.getAppNotifications(url: urlGetNotifications, callback: { (appNotifications) in
                            print(appNotifications)
                            //Refresh Notification tab with notifications array
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapControllerRefresh"), object: appNotifications)
                        })
                    }
                    let coordinate = friend.pos
                    let pin = Pin(coordinate: coordinate, title: friend.prenom, subtitle: friend.mail)
                    self.mapView.addAnnotation(pin)
                }
            }
        })
    }
    
    func updateUserPos(url:String){
        self.user.updatePosition(url: url, callback: { (response) in
            print("---Code de retour---")
            print(response)
        })
    }
}

