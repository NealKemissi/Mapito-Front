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
    var testNotifs = ["Votre ami se trouvait a coté de vous hier", "Votre amis a accepté votre invitations"]
    
    // Triggered when diplayed
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: Notification.Name(rawValue: "mapControllerRefresh"), object: nil)
    }
    
     func loadList(notification: Notification){
        //notification.
        print("notificationcontroller")
        print(notification)
     }
    
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
                print(self.allNotifs)
                print("test liste notifs")
                print(self.allNotifs)
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
    
    // Number of labels per cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testNotifs.count
    }
    
    // initialization of tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellNotif", for: indexPath) //as! TableCell
        
        cell.textLabel?.text = testNotifs[indexPath.row]
        
        return cell
    }
}
