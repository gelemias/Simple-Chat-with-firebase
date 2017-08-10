//
//  SVSearchView.swift
//  Survyy
//
//  Created by Guillermo Delgado on 10/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import Spring

class SVSearchView: UIControl, UITextFieldDelegate {

    var view: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var sendButtonLeadingConstraint: NSLayoutConstraint!

    let borderWidth: Float = 3.0
    let defaultSendButtonLeadingConstraintValue: CGFloat = -50.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    func initialize() {
        if let contentView: UIView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first! as? UIView {
            self.view = contentView
            self.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.addSubview(self.view)

            self.searchField.delegate = self
        }
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

    func removeTextfieldDecoration(textfield: UITextField) {

        let blueColor = UIColor(hex:SVConstants.lightBlue)
        let animation: CAAnimationGroup = self.animationForBorder(WithFrom: borderWidth, widthTo: 0.0,
                                                                  colorFrom: blueColor, colorTo: UIColor.clear,
                                                                  duration: 0.5)

        let layer: CALayer = (textfield.superview?.superview?.layer)!
        layer.add(animation, forKey:"color and width")
        layer.borderWidth = CGFloat(borderWidth)
        layer.borderColor = UIColor.clear.cgColor
    }

    @IBAction func doSearch(_ sender: UIButton) {
        if let springView = sender.superview as? SpringView {

            springView.animation = Spring.AnimationPreset.Pop.rawValue
            springView.curve = Spring.AnimationCurve.Spring.rawValue

            springView.animate()
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        let blueColor = UIColor(hex:SVConstants.lightBlue)

        let animation: CAAnimationGroup = self.animationForBorder(WithFrom: 0, widthTo: borderWidth,
                                                                  colorFrom: UIColor.clear, colorTo: blueColor,
                                                                  duration: 0.5)
        let layer = textField.superview?.superview?.layer

        layer?.add(animation, forKey:"color and width")
        layer?.borderWidth = CGFloat(borderWidth)
        layer?.borderColor = blueColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.removeTextfieldDecoration(textfield: textField)
        self.sendButtonLeadingConstraint.constant = defaultSendButtonLeadingConstraintValue
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.sendButtonLeadingConstraint.constant = string.characters.count > 0 ? 0.0 : self.defaultSendButtonLeadingConstraintValue
        UIView.animate(withDuration: 0.2) { 
            self.view.layoutIfNeeded()
        }
        
        return true
    }
}
