//
//  SVNavigationBarView.swift
//  Survyy
//
//  Created by Guillermo Delgado on 09/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVNavigationBarView: UIView {

    let imageSize: CGFloat = 50.0
    let imageMargin: CGFloat = 2.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {

        let height = rect.height * 3/4
        let path = UIBezierPath.init()

        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0.0))
        path.addLine(to: CGPoint(x: rect.width, y: height))
        path.addArc(withCenter: CGPoint(x: rect.width / 2, y: rect.height / 2),
                    radius: self.imageSize / 2.0 + imageMargin * 2.0,
                    startAngle: self.degreeToRad(degrees: 35),
                    endAngle: self.degreeToRad(degrees: 145),
                    clockwise: true)
        path.addLine(to: CGPoint(x: 0.0, y: height))
        path.close()

        UIColor(hex:SVConstants.backgroundGrey).setFill()

        path.fill()

        self.layer.shadowPath = path.cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10.0
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    func shouldShowShadow(showShadow: Bool) {
        UIView.animate(withDuration: 0.2) { 
            self.layer.shadowOpacity = showShadow ? 0.3 : 0.0
        }
    }

    func degreeToRad(degrees: CGFloat) -> CGFloat {
        return (.pi * degrees) / 180.0
    }
}
