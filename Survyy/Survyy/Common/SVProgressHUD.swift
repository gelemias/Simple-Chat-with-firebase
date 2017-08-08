//
//  SVProgressHUD.swift
//  Survyy
//
//  Created by Guillermo Delgado on 07/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import MBProgressHUD
import Spring

class SVProgressHUD: UIView {

    var hud: MBProgressHUD!

    convenience init(WithCustomHudInTopViewWithText text: String) {
        self.init(WithCustomHudIn: (SVProgressHUD.topViewController()?.view)!, text: text)
    }

    init(WithCustomHudIn view: UIView, text: String ) {

        super.init(frame: view.frame)

        self.hud = MBProgressHUD.showAdded(to: self, animated: true)
        self.hud.animationType = .fade
        self.hud.mode = .customView
        self.hud.backgroundColor = UIColor.white
        self.hud.label.font = UIFont.init(name: "SourceSansPro-Regular", size: 18)
        self.hud.label.textColor = UIColor(hex:SVConstants.darkBlue)
        self.hud.label.text = text

        let loadingView = UIImageView.init(image: UIImage.init(named: "loading"))
        self.runSpinAnimationOnView(loadingView, duration: 0.2, rotations: -1, repeatCount: .greatestFiniteMagnitude)
        self.hud.customView = loadingView

        view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hide() {

        self.hud.isHidden = true
        self.removeFromSuperview()
    }

    func runSpinAnimationOnView(_ view: UIView, duration: Double, rotations: Double, repeatCount: Float) {

        var rotationAnimation: CABasicAnimation!
        rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0 /* full rotation*/ * rotations * duration
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = repeatCount
        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)

        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
