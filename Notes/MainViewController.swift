//
//  MainViewController.swift
//  Notes
//
//  Created by user on 20.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func editeNote(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditeNote", sender: nil)

    }
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditeNote", sender: nil)

    }
    
}
