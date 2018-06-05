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

    // Local variables
    var timer = Timer()
    var cpt: Int = 0
    let user = User()
    let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
    var invisibleMode: Bool = false
    
    // Triggered when diplayed
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(setInvisibleMode), name: Notification.Name(rawValue: "switchStatus"), object: nil)
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
            self.user.token = tokenIsValid
        }else {
            print("No token found");
        }
        
        //scheduledTimerWithTimeInterval()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("---test recupération friends---")
        let url = env + myFriendsURL
        user.getFriends(url: url, callback: { (response, friends) in
            if(response == 200){
                for friend in friends {
                    if (friend.lastpos != nil) {
                        print("--friend.lastpos--")
                        print(friend.lastpos!)
                        let lastPin = Pin(coordinate: friend.lastpos!)
                        self.mapView.removeAnnotation(lastPin)
                    }
                }
            }
        })
    }*/
    
    func setInvisibleMode(notification: Notification){
        print("setInvisibleMode")
        let status = notification.object as! Bool
        self.invisibleMode = status
        print(self.invisibleMode)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(cpt==8){
            print("---locations---")
            print(locations)
            let longitude = locations[0].coordinate.longitude
            let latitude = locations[0].coordinate.latitude
            print(longitude)
            print(latitude)
            let url = env + updatePosURL
            print(url)
            if(self.invisibleMode == false){
                self.user.latitude = String(latitude)
                self.user.longitude = String(longitude)
                updateUserPos(url: url)
            }
            updateFriendsPosition()
            cpt = 0
        }
        cpt = cpt + 1
     }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateFriendsPosition), userInfo: nil, repeats: true)
    }
    
    func updateFriendsPosition(){
        NSLog("refreshing position..")
        // Get friends of user -> call api/friends
        print("---test recupération friends---")
        let url = env + myFriendsURL
        user.getFriends(url: url, callback: { (response, friends) in
            print("Response updateFriendsPosition")
            print(response)
            if(response == 200){
                for friend in friends {
                    //Faire enum
                    if(friend.inTheArea && friend.lastInTheArea == false){
                        let urlSendProxNotif = self.env + self.sendProxNotifURL
                        let urlGetNotifications = self.env + self.getNotificationsURL
                        print("---urlGetNotifications---")
                        print(urlGetNotifications)
                        friend.sendProxNotif(url: urlSendProxNotif, token: self.user.token, contenu: "se trouve près de vous") { (response, data) in
                            DispatchQueue.main.async {
                                if(response == 200){
                                    print("SendProxNotif 200")
                                    return;
                                } else {
                                    print("error")
                                    return;
                                }
                            }
                        }
                        self.user.getAppNotifications(url: urlGetNotifications, callback: { (appNotifications) in
                            print("----AppNotifications----")
                            print(appNotifications)
                            //Refresh Notification tab with notifications array
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapControllerRefresh"), object: appNotifications)
                        })
                    }
                    if(friend.inTheArea == false && friend.lastInTheArea == true){
                        let urlSendProxNotif = self.env + self.sendProxNotifURL
                        let urlGetNotifications = self.env + self.getNotificationsURL
                        friend.sendProxNotif(url: urlSendProxNotif, token: self.user.token, contenu: "n'est plus près de vous") { (response, data) in
                            DispatchQueue.main.async {
                                if(response == 200){
                                    print("SendProxNotif 200")
                                    return;
                                } else {
                                    print("error")
                                    return;
                                }
                            }
                        }
                        self.user.getAppNotifications(url: urlGetNotifications, callback: { (appNotifications) in
                            print("----AppNotifications2----")
                            print(appNotifications)
                            //Refresh Notification tab with notifications array
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapControllerRefresh"), object: appNotifications)
                        })
                    }
                    print("--friend.lastpos--")
                    print(friend.lastpos!)
                    let lastPin = Pin(coordinate: friend.lastpos!, title: "latPin", subtitle: "lastPin")
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    let coordinate = friend.pos
                    let pin = Pin(coordinate: coordinate, title: friend.prenom, subtitle: friend.mail)
                    self.mapView.addAnnotation(pin)
                    
                   /*let coordinate2 = CLLocationCoordinate2D(latitude: 48.840904, longitude: 2.3603)
                    let pinTest = Pin(coordinate: coordinate2, title: "test", subtitle: "test")
                    self.mapView.addAnnotation(pinTest)
                    self.mapView.removeAnnotation(pinTest)*/
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
    
    func displayMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Attention", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
}

