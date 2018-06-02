//
//  FriendsController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    // To be retrieved from back
    var amis = ["Arthur","Héloise","Neal","Robin", "Toto"]
    @IBInspectable var myFriendsURL : String!
    @IBInspectable var MyRequestsURL : String!
    @IBInspectable var suppMyFriendsURL : String!
    @IBInspectable var acceptMyFriendsURL : String!
    private var friends : [Friend] = [] // Will be an array of Friend
    private var mesDemandes : [AppNotification] = []
    private var user = User()
    var demandes = ["Florent", "Edouard"]
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    //var items = [["Florent", "Edouard"], ["Arthur","Héloise","Neal","Robin", "Toto"]]
    
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
            }
    //view will apear pour executer ce code a chaque chargement de la page
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            //on met dans la variable myToken le token enregistrer dans l'appli
            self.user.token = tokenIsValid
            print("Mytoken: "+self.user.token)
            let stringUrlRequest = env+self.MyRequestsURL!
            self.user.getAppNotifications(url: stringUrlRequest, callback: { (response) in
                self.mesDemandes = response
                print("test liste request")
                print(self.mesDemandes)
                self.table.reloadData()
            })
            
            let stringUrl = env+self.myFriendsURL!
            //recup liste friends
            self.user.getFriends(url: stringUrl, callback: { (response) in
                for friend in response {
                    self.amis.append(friend.prenom)
                }
                self.table.reloadData()
                self.friends = response
                print(self.amis)
                print("test liste friends")
                print(self.friends)
                self.table.reloadData()
            })
            //print("mes amis: ")
            //print(self.amis)
            print("test liste friends avant")
            print(self.friends)
        }else {
            print("aucun token");
        }
        self.table.reloadData();

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
    
    //nb de labels ( section correspond au num de la section 0=demandes amis et 1=amis)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return demandes.count
        } else if(section == 1){
            return friends.count
        } else {
            return 0
        }
    }
    
    //initialisation de la tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) //as! UITableViewCell
        
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellRequest", for: indexPath) as! TableCellRequest//as! UITableViewCell
            cell.textLabel?.text = demandes[indexPath.row]
            cell.displayMessage = { (message) in
                let myAlert = UIAlertController(title: "Accepter ?", message: message, preferredStyle: UIAlertControllerStyle.alert);
                //on ajoute les buttonAction oui et non
                myAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
                    let emailFriend = self.friends[indexPath.row].mail
                    let userDict = ["token": self.user.token, "mail": emailFriend] as [String: AnyObject]
                    let myAcceptUrl = self.env+self.acceptMyFriendsURL!
                    self.user.acceptRequest(url: myAcceptUrl, userDict: userDict, callback: { (response) in
                        DispatchQueue.main.async {
                            if(response == "200"){
                                print("acceptation reussie")
                                self.table.reloadData()
                                //print("mes nouveaux amis :")
                                //print(self.friends)
                            } else {
                                print("une erreur est survenue")
                            }
                        }
                        self.table.reloadData()
                    })
                    
                }))
                myAlert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: { (action: UIAlertAction!) in
                    print("acceptation annulée")
                }))
                //on affiche le myAlert
                self.present(myAlert, animated: true, completion: nil)
            }
            return cell
            
        } else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellFriends", for: indexPath) as! TableCellFriends
            cell.textLabel?.text = friends[indexPath.row].prenom
            //cell.textLabel?.text = amis[indexPath.row]
            // on appel la closure dans TableCellFriends
            cell.displayMessage = { (message) in
                let myAlert = UIAlertController(title: "Attention", message: message, preferredStyle: UIAlertControllerStyle.alert);
                //on ajoute les buttonAction oui et non
                myAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
                    print("test reussie")
                    let emailFriend = self.friends[indexPath.row].mail
                    let userDict = ["token": self.user.token, "mail": emailFriend] as [String: AnyObject]
                    let mySuppUrl = self.env+self.suppMyFriendsURL!
                    self.user.deleteFriend(url: mySuppUrl, userDict: userDict, callback: { (response) in
                        DispatchQueue.main.async {
                            if(response == "200"){
                                print("suppression reussie")
                                self.table.reloadData()
                                print("mes nouveaux amis :")
                                print(self.friends)
                            } else {
                                print("une erreur est survenue")
                            }
                        }
                        self.table.reloadData()
                    })
                    
                }))
                myAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
                    print("suppression annulée")
                }))
                //on affiche le myAlert
                self.present(myAlert, animated: true, completion: nil)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellRequest", for: indexPath) //as! UITableViewCell
            cell.textLabel?.text = amis[indexPath.row]
            return cell
        }
        /*else if(indexPath.row>1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) //as! UITableViewCell
            cell.textLabel?.text = amis[indexPath.row]
            return cell
        }*/
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
    }
}

