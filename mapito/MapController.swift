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

class MapController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    //path de la methode modification ajout amis
    @IBInspectable var myFriendsURL: String!
    
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    var timer = Timer()
    var cpt: Double = 0.0
    var lastPin: Pin?
    private var friends : Array<Friend>? // Will be an array of Friend
    private var user = User()
    var Mytoken : String = "test"
    
    override func viewDidLoad() {
        //scheduledTimerWithTimeInterval()
        super.viewDidLoad()
        mapView.setUserTrackingMode(.follow, animated: true)
        
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.Mytoken = tokenIsValid
            print("Mytoken: "+self.Mytoken)
        }else {
            print("aucun token");
        }
        
        updateFriendsPosition()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateUserPos()
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
                        let lastPin = Pin(coordinate: friend.lastpos!, title: "Pin", subtitle: "Best pin ever")
                            self.mapView.removeAnnotation(lastPin)
                    }
                    if(friend.inTheArea){
                        friend.sendProxNotif(token: self.Mytoken, email: friend.mail)
                    }
                    
                    print("---friend pos---")
                    print(friend.pos)
                    let coordinate = friend.pos
                    let pin = Pin(coordinate: coordinate, title: friend.prenom, subtitle: friend.mail)
                    self.mapView.addAnnotation(pin)
                }
            }
        })
    }
    
    func updateUserPos(){
        print("didupdate user location")
    }
}

