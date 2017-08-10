//
//  SVTabBarView.swift
//  Survyy
//
//  Created by Guillermo Delgado on 09/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVTabBarView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        // Drawing code

        let theta = .pi - atan2(rect.width / 2.0, rect.height) * 2.0
        let radius = rect.size.height / (1.0 - cos(theta))

        let path = UIBezierPath.init()
        path.move(to: CGPoint(x:0, y:rect.height))
        path.addArc(withCenter: CGPoint.init(x: rect.width / 2.0, y: radius),
                    radius: radius, startAngle: .pi/2 * 3 + theta, endAngle: .pi/2 * 3 - theta, clockwise: false)
        path.close()
        path.fill()

        self.layer.shadowPath = path.cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

        let gradient = CAGradientLayer()
        gradient.frame = path.bounds

        gradient.colors = [UIColor(hex:SVConstants.leftGradientColor).cgColor,
                           UIColor(hex:SVConstants.rightGradientColor).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradient.endPoint = CGPoint.init(x: 1, y: 0.5)

        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        shapeMask.shouldRasterize = true
        shapeMask.rasterizationScale = UIScreen.main.scale

        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
    }
}
