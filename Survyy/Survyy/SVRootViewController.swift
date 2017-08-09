//
//  ViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 03/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVRootViewController: SVBaseViewController {

    let kShowLoginSegue = "ShowLoginSegue"
    let kShowHomeSegue = "ShowHomeSegue"
    let kShowIntroSegue = "ShowIntroSegue"

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        // Login
        if !SVLoginManager.shared.isUserAuthorized() {
            self.performSegue(withIdentifier: kShowLoginSegue, sender: self)
        }
        // Intro
        else if SVSettingsManager.sharedInstance.shouldSkipIntro == false {
            self.performSegue(withIdentifier: kShowIntroSegue, sender: self)
            UserDefaults.standard.setValue(true, forKey: SVConstants.shouldSkipIntroKey)
        }
        // Home
        else {
            self.performSegue(withIdentifier: kShowHomeSegue, sender: self)
        }
    }
}
