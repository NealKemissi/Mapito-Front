//
//  FriendsController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // To be retrieved from back
    var amis = ["Arthur","Héloise","Neal","Robin"]
    var demandes = ["Florent", "Edouard"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Grouped tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //Titles of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0){
            return "Demandes d'amis"
        } else if(section == 1){
            return "Amis"
        } else {
            return ""
        }
    }
    
    //nb de labels
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return demandes.count
        } else if(section == 1){
            return amis.count
        } else {
            return 0
        }
    }
    
    //initialisation de la tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) //as! UITableViewCell
        
        if(indexPath.row == 0){
            cell.textLabel?.text = demandes[indexPath.row]
        } else if(indexPath.row == 1){
            cell.textLabel?.text = amis[indexPath.row]
        } else {
            cell.textLabel?.text = "else"
        }
        
        
        return cell
    }
}

