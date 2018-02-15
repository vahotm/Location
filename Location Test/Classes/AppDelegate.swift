//
//  AppDelegate.swift
//  Location Test
//
//  Created by Ivan Samalazau on 12.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DataManager.setup()
        return true
    }
}

