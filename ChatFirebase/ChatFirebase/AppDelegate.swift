//
//  AppDelegate.swift
//  ChatFirebase
//
//  Created by Guillermo Delgado on 11/05/2017.
//  Copyright © 2017 ChatFirebase. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        return true
    }
}
