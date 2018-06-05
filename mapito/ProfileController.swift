//
//  ProfileController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var invisibleMode: UISwitch!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // API paths
    @IBInspectable var userFieldURL: String!
    
    // API url
    let env = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
    
    // Local variables
    let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
    let user = User()
    var champs = ["nom", "prenom", "mail", "password"]
    //var indexArray = ["Info personnelles", "Info Connexion"]
    
    @IBAction func logout(_ sender: UIButton) {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.setRounded()
        profileImageView.setImageColor(color: UIColor.purple)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // Number of labels per cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return champs.count
    }
    
    // Initialisation of tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        
        cell.textLabel?.text = "Modifier "+champs[indexPath.row]
        
        return cell
    }
    
    // When label tapped -> redirection to DetailedProfileController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let dePC = mainStory.instantiateViewController(withIdentifier: "DetailedProfileController") as! DetailedProfileController
        dePC.field = champs[indexPath.row]
        self.navigationController?.pushViewController(dePC, animated: true)
        //self.present(deCV, animated: true);
    }
    
}

