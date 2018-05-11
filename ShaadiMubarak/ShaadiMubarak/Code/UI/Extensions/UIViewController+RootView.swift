//
//  UIViewController+RootView.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 11/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var rootViewController: RootViewController? {
        var selfController = self
        while let parentController = selfController.parent {
            if  let controller = parentController as? RootViewController {
                return controller
            } else {
                selfController = parentController
            }
        }
        return nil
    }
}
