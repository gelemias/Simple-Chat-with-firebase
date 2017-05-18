//
//  AppDelegate.swift
//  Survyy
//
//  Created by Guillermo Delgado on 11/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        return true
    }
}

