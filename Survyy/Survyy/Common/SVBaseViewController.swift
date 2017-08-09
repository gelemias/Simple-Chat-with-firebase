//
//  SVBaseViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 08/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import Spring

class SVBaseViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func animateButton(btn: UIButton?) {
        if let springBtn = btn as? SpringButton {

            springBtn.animation = Spring.AnimationPreset.Pop.rawValue
            springBtn.curve = Spring.AnimationCurve.Spring.rawValue

            springBtn.animate()

        } else if let springView = btn?.superview as? SpringView {

            springView.animation = Spring.AnimationPreset.Pop.rawValue
            springView.curve = Spring.AnimationCurve.Spring.rawValue

            springView.animate()
        }
    }
}
