//
//  FriendsController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var amis = ["Arthur","Héloise","Neal","Robin"]
    @IBInspectable var myFriendsURL : String!
    var Mytoken : String = "test"
    
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
    
    //nb de label
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amis.count
    }
    
    //initialisation de la tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) //as! TableCell
        
        cell.textLabel?.text = amis[indexPath.row]
        
        return cell
    }
}

