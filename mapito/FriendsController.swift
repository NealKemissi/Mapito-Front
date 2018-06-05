//
//  FriendsController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit
import Contacts

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var findFriendTextField: MapitoTextField!
    
    // API paths
    @IBInspectable var myFriendsURL: String!
    @IBInspectable var MyRequestsURL: String!
    @IBInspectable var suppMyFriendsURL: String!
    @IBInspectable var acceptMyFriendsURL: String!
    @IBInspectable var DeleteRequestURL: String!
    @IBInspectable var getPotentialFriendsURL: String!
    @IBInspectable var addFriendURL: String!
    
    // API URL
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Local variables
    private var friends: [Friend] = []
    private var friendRequests: [AppNotification] = []
    private var friendRequestsMails: [String] = []
    private var user = User()
    //private var myContactString = ["Arthur", "Héloise", "Neal", "Robin"]
    private var myContacts : [Friend] = []
    
    // Voir si fonctionne
    @IBAction func editchange(_ sender: MapitoTextField, forEvent event: UIEvent) {
        let mainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let deFC = mainStory.instantiateViewController(withIdentifier: "NewFriendController") as! NewFriendController
        deFC.friendResearchValue = self.findFriendTextField.text!
        self.navigationController?.pushViewController(deFC, animated: true)
        findFriendTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tokenIsValid : String = UserDefaults.standard.string(forKey: "token" ){
            self.user.token = tokenIsValid
        }
        //fetchContacts()
        //self.table.reloadData()
    }
    
    // viewWillAppear -> to execute code at each page loading
    override func viewWillAppear(_ animated: Bool) {
        // Get friendRequests
        let friendRequestsURL = env + self.MyRequestsURL!
        self.user.getAppNotifications(url: friendRequestsURL, callback: { (response) in
            self.friendRequests = response
            self.friendRequestsMails = response.map( { (appNotification: AppNotification) in appNotification.mail} )
            self.table.reloadData()
            print("test liste friendrequests")
            print(self.friendRequests)
        })
        
        // Get friends
        let getFriendsURL = env+self.myFriendsURL!
        // à gérer cas 404
        self.user.getFriends(url: getFriendsURL, callback: { (response, friends) in
            self.friends = friends
            self.fetchContacts()
            self.table.reloadData()
            print("test liste friends")
            print(self.friends)
        })
    
        self.table.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Grouped tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // Titles of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0){
            return "Demandes d'amis"
        } else if(section == 1){
            return "Amis"
        } else if(section==2){
            return "Vos contact"
        } else {
            return ""
        }
    }
    
    // Number of labels (section corresponds to section id: 0 = friendRequests et 1 = friends)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return friendRequestsMails.count
        } else if(section == 1){
            return friends.count
        } else if(section == 2){
            return myContacts.count
        } else {
            return 0
        }
    }
    
    // Initialization of tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Action in friendRequests section
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellRequest", for: indexPath) as! TableCellRequest
            cell.textLabel?.text = friendRequestsMails[indexPath.row]
            
            // Action accept request (closure in TableCellRequest)
            cell.displayMessageAccept = { (message) in
                let myAlert = UIAlertController(title: "Accepter ?", message: message, preferredStyle: UIAlertControllerStyle.alert);
                // Add action buttons yes and no
                myAlert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: { (action: UIAlertAction!) in
                    print("Acceptation annulée")
                }))
                myAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
                    let emailFriend = self.friendRequests[indexPath.row].mail
                    let userDict = ["token": self.user.token, "mail": emailFriend] as [String: AnyObject]
                    let myAcceptUrl = self.env+self.acceptMyFriendsURL!
                    self.user.acceptFriendRequest(url: myAcceptUrl, userDict: userDict, callback: { (response, data) in
                        DispatchQueue.main.async {
                            if(response == 200){
                                self.displayMessage(Mytitle: "Félicitations", userMessage: data);
                                return;
                            } else {
                                self.displayMessage(Mytitle: "Attention", userMessage: data);
                                return;
                            }
                        }
                        self.table.reloadData()
                    })
                }))
                // myAlert displayed
                self.present(myAlert, animated: true, completion: nil)
            }
            
            // Action deny request (closure in TableCellRequest)
            cell.displayMessageDeny = { (message) in
                let myAlert = UIAlertController(title: "Refuser ?", message: message, preferredStyle: UIAlertControllerStyle.alert);
                // Add action buttons yes and no
                myAlert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: { (action: UIAlertAction!) in
                    print("Refus annulé")
                }))
                myAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
                    let emailFriendRequest = self.friendRequests[indexPath.row].mail
                    let typeFriendRequest = self.friendRequests[indexPath.row].type
                    let userDict = ["token": self.user.token, "type": typeFriendRequest!, "mail": emailFriendRequest] as [String: AnyObject]
                    let myDenyUrl = self.env+self.DeleteRequestURL!
                    self.user.denyFriendRequest(url: myDenyUrl, userDict: userDict, callback: { (response, data) in
                        DispatchQueue.main.async {
                            if(response == 200){
                                self.displayMessage(Mytitle: "Félicitations", userMessage: data);
                                return;
                            } else {
                                self.displayMessage(Mytitle: "Attention", userMessage: data);
                                return;
                            }
                        }
                        self.table.reloadData()
                    })
                }))
                // myAlert displayed
                self.present(myAlert, animated: true, completion: nil)
            }
            return cell
            
        // Action in friends section
        } else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellFriends", for: indexPath) as! TableCellFriends
            cell.textLabel?.text = friends[indexPath.row].prenom

            // Action delete friend (closure in TableCellFriends)
            cell.displayMessage = { (message) in
                let myAlert = UIAlertController(title: "Attention", message: message, preferredStyle: UIAlertControllerStyle.alert);
                // Add action buttons yes and no
                myAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
                    print("Suppression annulée")
                }))
                myAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
                    let emailFriend = self.friends[indexPath.row].mail
                    let mySuppUrl = self.env+self.suppMyFriendsURL!
                    self.user.deleteFriend(url: mySuppUrl, emailFriend: emailFriend, callback: { (response, data) in
                        DispatchQueue.main.async {
                            if(response == 200){
                                self.displayMessage(Mytitle: "Félicitations", userMessage: data)
                                return;
                            } else {
                                self.displayMessage(Mytitle: "Attention", userMessage: data)
                                return;
                            }
                        }
                        self.table.reloadData()
                    })
                    
                }))
                // myAlert displayed
                self.present(myAlert, animated: true, completion: nil)
            }
            return cell
        } else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellContact", for: indexPath) as! TableCellContact
            cell.textLabel?.text = myContacts[indexPath.row].mail
            
            cell.displayMessageAcceptC = { (message) in
                let myAlert = UIAlertController(title: "Accepter ?", message: message, preferredStyle: UIAlertControllerStyle.alert);
                // Add action buttons yes and no
                myAlert.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction!) in
                    print("acceptation contact annulée")
                }))
                myAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
                    print("demande contact envoyé")
                    let emailFriend = self.myContacts[indexPath.row].mail
                    let userDict = ["token": self.user.token, "mail": emailFriend] as [String: AnyObject]
                    let stringUrl = self.env+self.addFriendURL!
                    print("addFriend")
                    print(stringUrl)
                    self.user.sendFriendRequest(url: stringUrl, userDict: userDict) { (response, data) in
                        DispatchQueue.main.async {
                            if(response == 200){
                                self.displayMessage(Mytitle: "Félicitations", userMessage: data);
                                return;
                            } else {
                                self.displayMessage(Mytitle: "Attention", userMessage: data);
                                return;
                            }
                        }
                    }
                }))
                self.table.reloadData()
                // myAlert displayed
                self.present(myAlert, animated: true, completion: nil)
            }
            return cell
        }
        
        // Action in other section
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellRequest", for: indexPath) //as! UITableViewCell
            cell.textLabel?.text = friendRequestsMails[indexPath.row]
            return cell
        }
        /*else if(indexPath.row>1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) //as! UITableViewCell
            cell.textLabel?.text = amis[indexPath.row]
            return cell
        }*/
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
    }
    
    func displayMessage(Mytitle: String ,userMessage: String)
    {
        let myAlert = UIAlertController(title: Mytitle, message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let Ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(Ok);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    
    //get my contact phone
    private func fetchContacts() {
        let store = CNContactStore()
        var phoneContacts = ""
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("failed acces contact", err)
                return
            }
            if granted {
                print("access success")
                //clées des valeurs a recup
                let keys = [CNContactPhoneNumbersKey]
                //requete qui va recup les phoneNumbersKey
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    //enumeration des contacts
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        //print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        //phoneContacts.append(contact.phoneNumbers.first?.value.stringValue ?? "")
                        phoneContacts = phoneContacts+(contact.phoneNumbers.first?.value.stringValue)!+";"
                    })
                } catch let err{
                    print("failed to enumerate contact :",err)
                }
                print(phoneContacts)
                self.user.getPotentialFriends(url: self.env+self.getPotentialFriendsURL, listContact: phoneContacts, callback: { (response, listResponse) in
                    DispatchQueue.main.async {
                        if(response == 200){
                            self.myContacts = listResponse
                            self.table.reloadData()
                            print("test liste contact : ", self.myContacts)
                        } else {
                            print("recuperer potentiel amis echoué ", response)
                        }
                    }
                    self.table.reloadData()
                })
                
            } else {
                print("access denied")
            }
        }
    }
}

