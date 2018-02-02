//
//  AppDelegate.swift
//  Example
//
//  Created by Martin MOIZARD-LANVIN on 15/09/16.
//  Copyright © 2016 Akane. All rights reserved.
//

import UIKit
import Akane

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?
    // FIXME
    let context = AppContext()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let navigationController = self.window?.rootViewController as! UINavigationController
        let homeViewController = navigationController.viewControllers.first as! HomeViewController

        homeViewController.renderScene(SearchAuthorsViewModel(),
                                       context: self.context)

        return true
    }
}

// FIXME?
class AppContext: Context {

}

