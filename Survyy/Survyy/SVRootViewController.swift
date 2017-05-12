//
//  SVRootViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit

class SVRootViewController: UIViewController {

    let kShowLoginSegue = "ShowLoginSegue"
    let kShowIntroSegue = "ShowIntroSegue"
    let kShowHomeSegue = "ShowHomeSegue"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !SVLoginManager.shared.isUserAuthorized() {
            self.performSegue(withIdentifier: kShowLoginSegue, sender: self)
        }
        else if SVPersistenceManager.shared.isNewVersion() {
            self.performSegue(withIdentifier: kShowIntroSegue, sender: self)
        }
        else {
            self.performSegue(withIdentifier: kShowHomeSegue, sender: self)
        }
    }
}
