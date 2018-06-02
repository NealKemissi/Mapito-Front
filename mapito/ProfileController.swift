//
//  ProfileController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var invisibleMode: UISwitch!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBInspectable var userFieldURL: String! //recuperation de
    
    let user = User()
    
    //deconnexion
    @IBAction func deconnexion(_ sender: UIButton) {        
        let defaults = UserDefaults.standard;
        defaults.removeObject(forKey: "token");
        defaults.synchronize();
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let navigationAuthentication = storyboard.instantiateViewController(withIdentifier: "NavigationAuthentication") as! UINavigationController;
        self.present(navigationAuthentication, animated: true);
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func switchIsChanged(_ sender: Any, forEvent event: UIEvent) {
        print("--invisibleMode--")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "switchStatus"), object: invisibleMode.isOn)
    }
    //var indexArray = ["Info personnelles","Info Connexion"]
    var champs = ["nom","prenom","mail","password"]
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.setRounded()
        profileImageView.setImageColor(color: UIColor.purple)
        //self.user.getFieldValue(url: <#T##String#>, callback: )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    //nb de separation de label
    func numberOfSections(in tableView: UITableView) -> Int {
        return indexArray.count
    }
    //afficher info perso info connexion
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexArray[section]
    }
    */
    
    //nb de label par cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return champs.count
    }
    //initialisation de la tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) //as! TableCell
        
        cell.textLabel?.text = "Modifier "+champs[indexPath.row]
        
        return cell
    }
    
    //une fois cliquer sur un label on est redirigé vers la page DetailedProfileController
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let mainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let dePC = mainStory.instantiateViewController(withIdentifier: "DetailedProfileController") as! DetailedProfileController
        dePC.field = champs[indexPath.row]
        self.navigationController?.pushViewController(dePC, animated: true)
        //self.present(deCV, animated: true);
    }
    
}

