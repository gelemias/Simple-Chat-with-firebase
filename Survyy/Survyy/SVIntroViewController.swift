//
//  SVIntroViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit

class SVIntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SVPersistenceManager.shared.currentVersion = Float(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
    }
}
