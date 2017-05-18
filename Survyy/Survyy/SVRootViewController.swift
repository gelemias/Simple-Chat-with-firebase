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
    let kShowHomeSegue = "ShowHomeSegue"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !SVLoginManager.shared.isUserAuthorized() {
            self.performSegue(withIdentifier: kShowLoginSegue, sender: self)
        } else {
            self.performSegue(withIdentifier: kShowHomeSegue, sender: self)
        }
    }
}
