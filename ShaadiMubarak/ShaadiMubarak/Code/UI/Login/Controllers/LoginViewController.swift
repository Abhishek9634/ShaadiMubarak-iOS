//
//  LoginViewController.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 11/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginAction(_ sender: Any) {
        AppDelegate.shared.showRootView()
    }
}

