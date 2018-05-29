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
    @IBInspectable var myFriendsURL : String!
    var Mytoken : String = "test"
    var demandes = ["Florent", "Edouard"]

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
            let stringUrl = self.myFriendsURL!+"/"+Mytoken
            let baseUrl = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // trouver comment faire pour envoyer le field (qui differe selon chaque page)
            let request = URLRequest(url: baseUrl)
            let session = URLSession.shared.dataTask(with: request , completionHandler: { (data, response, error) in
                if let myData = String(data: data!, encoding: .utf8) {
                    print(myData)
                    //self.myValue = myData //recup liste friends
                    print("Mytoken: "+self.Mytoken)
                }
            })
            session.resume()
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

