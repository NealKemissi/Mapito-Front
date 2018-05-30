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
    var amis = ["Arthur","Héloise","Neal","Robin", "toto"]
    @IBInspectable var myFriendsURL : String!
    var Mytoken : String = "test"
    private var friends : Array<Friend>? // Will be an array of Friend
    private var user = User()
    var demandes = ["Florent", "Edouard"]
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    @IBOutlet weak var findFriendTextField: MapitoTextField!
    
    @IBAction func editchange(_ sender: MapitoTextField, forEvent event: UIEvent) {
        let mainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let deFC = mainStory.instantiateViewController(withIdentifier: "NewFriendController") as! NewFriendController
        deFC.friendResearchValue = self.findFriendTextField.text!
        self.navigationController?.pushViewController(deFC, animated: true)
        findFriendTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.Mytoken = tokenIsValid
            print("Mytoken: "+self.Mytoken)
            let stringUrl = env+self.myFriendsURL!+Mytoken
            //recup liste friends
            self.user.getFriends(url: stringUrl, callback: { (response) in
                for friend in response {
                    //on veut juste les prenom
                    print(friend.prenom)
                    self.amis.append(friend.prenom)
                    print(self.amis)
                }
            })
            print("mes amis: ")
            print(self.amis)
        }else {
            print("aucun token");
        }

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

