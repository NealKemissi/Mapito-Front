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
    var timer = Timer()
    var cpt: Double = 0.0
    var lastPin: Pin?
    private var friends : Array<Friend>? // Will be an array of Friend
    private var user = User()
    
    override func viewDidLoad() {
        updateFriendsPosition()
        //scheduledTimerWithTimeInterval()
        super.viewDidLoad()
        mapView.setUserTrackingMode(.follow, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateFriendsPosition), userInfo: nil, repeats: true)
    }
    
    func updateFriendsPosition(){
        NSLog("refreshing position..")
        /*if(lastPin != nil){
            mapView.removeAnnotation(lastPin!)
        }
        cpt += 0.001
        let lat = 48.851164 - cpt
        let lng = 2.348156 + cpt
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let pin = Pin(coordinate: coordinate, title: "Pin", subtitle: "Best pin ever")
        lastPin = pin
        mapView.addAnnotation(pin)*/
        
        // Get friends of user -> call api/friends
        print("---test recupération friends---")
        friends = user.getFriends(url: "poet")
        for friend in friends! {
            if (friend.lastpos != nil) {
                let lastPin = Pin(coordinate: friend.lastpos!, title: "Pin", subtitle: "Best pin ever")
                mapView.removeAnnotation(lastPin)
            }
            let coordinate = friend.pos
            friend.setLastpos(pos: coordinate)
            let pin = Pin(coordinate: coordinate, title: "Pin", subtitle: "Best pin ever")
            mapView.addAnnotation(pin)
        }
    }
}

