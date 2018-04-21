//
//  FirstViewController.swift
//  mapito
//
//  Created by m2sar on 12/04/2018.
//  Copyright © 2018 code2geny. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var indexArray = ["Info personnelles","Info Connexion"]
    var champs = ["Modifier Nom","Modifier Prénom","Modifier Email","Modifier Mot de passe"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        cell.textLabel?.text = champs[indexPath.row]
        
        return cell
    }
    
    //une fois cliquer sur un label on est redirigé vers la page profileController
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let mainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let deCV = mainStory.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        self.navigationController?.pushViewController(deCV, animated: true)
    }
}

