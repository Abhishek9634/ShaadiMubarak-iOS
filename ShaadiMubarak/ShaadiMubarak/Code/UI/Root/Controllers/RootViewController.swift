//
//  RootViewController.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 11/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    static var newInstance: RootViewController {
        let storyboard = UIStoryboard(name: "Root", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! RootViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RootViewController {
    
    func showProfile() {
        self.selectedIndex = 1
    }
    
    func showHome() {
        self.selectedIndex = 0
    }
}
