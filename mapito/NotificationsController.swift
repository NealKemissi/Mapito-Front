//
//  NotificationsController.swift
//  mapito
//
//  Created by m2sar on 30/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class NotificationsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    
    // API paths
    @IBInspectable var MyNotifsURL: String!
    
    // API URL
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String   
    
    // Local variables
    private var user = User()
    private var allNotifs : [AppNotification] = []
    //private var indicator = UIActivityIndicatorView()
    /*--viewdidload
     indicator.center = self.view.center
     indicator.activityIndicatorViewStyle = .whiteLarge
     self.view.addSubview(indicator)
     indicator.startAnimating()
    */
    
    // Triggered when diplayed
    /*
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: Notification.Name(rawValue: "mapControllerRefresh"), object: nil)
    }
    
     func loadList(notification: Notification){
        //notification.
        print("notificationcontroller")
        print(notification)
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.user.token = tokenIsValid
            let stringUrl = env+self.MyNotifsURL!
            print("Mytoken: "+self.user.token)
            self.user.getAppNotifications(url: stringUrl, callback: { (response) in
                self.allNotifs = response

                print("-----------------------------------------------------------------")
                print(self.allNotifs)
                print("test liste notifs")
                //print(self.allNotifs[0].date)
                self.table.reloadData()

            })
            print("test liste notifs avant")
            print(self.allNotifs)
        }else {
            print("aucun token");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Grouped tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return allNotifs.count //tester plus tard avec fct dates notif
    }
    // Titles of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        for i in 0...self.allNotifs.count {
            if(section==i){
              return self.allNotifs[i].date?.description
            }
        }
        return ""
    }
    
    // Number of labels per cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // initialization of tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellNotif", for: indexPath) as! TableCellNotif
        for i in 0...self.allNotifs.count {
            if(indexPath.section == i) {
                cell.textLabel?.text = allNotifs[i].message
                return cell
            }
        }
        return cell
    }
}
