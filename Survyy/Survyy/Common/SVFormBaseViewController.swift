//
//  SVFormBaseViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 04/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVFormBaseViewController: UIViewController, UITextFieldDelegate {

    let kBorderWidth: Float = 3.0

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    func showValidationErrorIn(_ textfield: UITextField) {

        let blueColor = UIColor(hex:SVConstants.lightBlue)
        let redColor = UIColor(hex:SVConstants.lightRed)

        let aniBlue: CAAnimationGroup = self.animationForBorder(WithFrom: kBorderWidth, widthTo: 0,
                                                                colorFrom: blueColor, colorTo: UIColor.clear,
                                                                duration: 0.5)

        let layer = textfield.superview?.superview?.layer

        layer?.add(aniBlue, forKey:"color1")

        let aniRed: CAAnimationGroup = self.animationForBorder(WithFrom: kBorderWidth, widthTo: kBorderWidth,
                                                                colorFrom: UIColor.clear, colorTo: redColor,
                                                                duration: 0.5)

        layer?.add(aniRed, forKey:"color2")

        layer?.borderWidth = CGFloat(kBorderWidth)
        layer?.borderColor = redColor.cgColor
    }

    func animationForBorder(WithFrom widthFrom: Float, widthTo: Float, colorFrom: UIColor, colorTo: UIColor, duration: Float) -> CAAnimationGroup {

        let color: CABasicAnimation = CABasicAnimation.init(keyPath: "borderColor")
        color.fromValue = colorFrom.cgColor
        color.toValue   = colorTo.cgColor

        let width: CABasicAnimation = CABasicAnimation.init(keyPath: "borderWidth")
        width.fromValue = widthFrom
        width.toValue   = widthTo

        let both: CAAnimationGroup = CAAnimationGroup.init()
        both.duration   = CFTimeInterval.init(duration)
        both.animations = [color, width]
        both.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)

        return both
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    func removeTextfieldDecoration(textfield: UITextField) {

        let blueColor = UIColor(hex:SVConstants.lightBlue)
        let animation: CAAnimationGroup = self.animationForBorder(WithFrom: kBorderWidth, widthTo: 0.0,
                                                                  colorFrom: blueColor, colorTo: UIColor.clear,
                                                                  duration: 0.5)

        let layer: CALayer = (textfield.superview?.superview?.layer)!
        layer.add(animation, forKey:"color and width")
        layer.borderWidth = CGFloat(kBorderWidth)
        layer.borderColor = UIColor.clear.cgColor
    }

}
