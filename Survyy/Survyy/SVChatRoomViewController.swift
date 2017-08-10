//
//  SVChatRoomViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 10/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVChatRoomViewController: SVBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat Room"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
