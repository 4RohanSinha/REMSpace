//
//  TabBarRootViewController.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/18/23.
//

import UIKit

class TabBarRootViewController: UITabBarController, UITabBarControllerDelegate {

    var dataController: DataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedViewController = selectedViewController {
            injectViewControllerWithDataController(viewController: selectedViewController)
        }
    }
    
    func injectViewControllerWithDataController(viewController: UIViewController) {
        if let viewController = viewController as? CoreDataStackViewController {
            viewController.dataController = dataController
        } else if let viewController = (viewController as? UINavigationController)?.topViewController as? CoreDataStackViewController {
            viewController.dataController = dataController
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        injectViewControllerWithDataController(viewController: viewController)
        return true
    }

}
