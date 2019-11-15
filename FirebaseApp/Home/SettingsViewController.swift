//
//  SettingsViewController.swift
//  FirebaseApp
//
//  Created by Gianluca Bonora on 15/11/19.
//  Copyright © 2019 gglobalapps. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
    }

}
