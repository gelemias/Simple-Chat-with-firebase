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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.stylizeNavBar()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"backgroundImage")!)
    }

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

    func stylizeNavBar() {
        if let navBar = self.navigationController?.navigationBar {

            // Appearance

            let bottomBorderView = UIView(frame: CGRect(x: 0, y: navBar.frame.height, width: navBar.frame.width, height: 1))

            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: navBar.frame.width, height: 1)

            gradient.colors = [UIColor(hex:SVConstants.leftGradientColor).cgColor,
                               UIColor(hex:SVConstants.rightGradientColor).cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.startPoint = CGPoint.init(x: 0, y: 0.5)
            gradient.endPoint = CGPoint.init(x: 1, y: 0.5)

            bottomBorderView.layer.addSublayer(gradient)
            navBar.addSubview(bottomBorderView)

            // Title

            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,
                                          NSFontAttributeName: UIFont(name: SVConstants.SourceSansProSemibold, size: 18)!]
            
            // Back button
            navBar.backIndicatorImage = UIImage(named: "back-icon")
            navBar.backIndicatorTransitionMaskImage = UIImage(named: "back-icon")
            navBar.tintColor = UIColor.black
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }

    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
