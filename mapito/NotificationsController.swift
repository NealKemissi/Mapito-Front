//
//  NotificationsController.swift
//  mapito
//
//  Created by m2sar on 30/05/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import Foundation
import UIKit

class NotificationsController: UIViewController {
    
    
    @IBOutlet weak var table: UITableView!
    @IBInspectable var MyNotifsURL: String!
    private var user = User()
    private var allNotifs : [AppNotification] = []
    var testNotifs = ["Votre ami se trouvait a coté de vous hier", "Votre amis a accepté votre invitations"]
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Triggered when diplayed
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: Notification.Name(rawValue: "mapControllerRefresh"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.user.token = tokenIsValid
            print("Mytoken: "+self.user.token)
        }else {
            print("aucun token");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadList(notification: Notification){
        //notification.
        print("notificationcontroller")
        print(notification)
    }
    
    //Grouped tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Titles of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0){
            return "Toutes mes notifs"
        } else {
            return ""
        }
    }
    
    //nb de labels ( section correspond au num de la section 0=demandes amis et 1=amis)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return testNotifs.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellNotif", for: indexPath) as! TableCellRequest//as! UITableViewCell
            cell.textLabel?.text = testNotifs[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellNotif", for: indexPath) as! TableCellRequest//as! UITableViewCell
            cell.textLabel?.text = testNotifs[indexPath.row]
            return cell
        }
    }
    
}
