//
//  SVDetailBusinessViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 14/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVDetailBusinessViewController: SVBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if businessItem == nil {
            fatalError("businessItem cannot be nil")
        }

        self.title = self.businessItem?.name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    var businessItem: SVBusinessItem?

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
