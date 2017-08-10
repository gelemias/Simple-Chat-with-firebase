//
//  SVCardView.swift
//  Survyy
//
//  Created by Guillermo Delgado on 08/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import Spring

class SVCardView: UIView {

    @IBOutlet weak var container: UIView?
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var cardView: SpringView!
    @IBOutlet weak var descriptionLabel: UILabel!

    var view: UIView!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, title: String, description: String, cardView: UIView) {
        super.init(frame: frame)

        if let contentView: UIView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first! as? UIView {

            view = contentView
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)

            self.setup(title, description: description, cardView: cardView)
        }
    }

    func animateCardView() {
        
        self.cardView.animation = Spring.AnimationPreset.Wobble.rawValue
        self.cardView.curve = Spring.AnimationCurve.EaseInOut.rawValue
        self.cardView.delay = 0.5
        self.cardView.animate()
    }

// MARK: - internal methods

    internal func setup(_ title: String, description: String, cardView: UIView) {

        let metrics = ["width": self.bounds.width, "height": self.bounds.height]
        let views = ["contentView": self.view!, "self": self]

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView(width)]",
                                                           options: .alignAllLeft, metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(height)]",
                                                           options: .alignAllLeft, metrics: metrics, views: views))

        self.titleLabel.text = title
        self.cardView.addSubview(cardView)
        cardView.contentMode = .center

        cardView.translatesAutoresizingMaskIntoConstraints = false

        self.cardView.addConstraints([NSLayoutConstraint(item: cardView, attribute: .top, relatedBy: .equal,
                                                         toItem: self.cardView, attribute: .top, multiplier: 1.0,
                                                         constant: 0.0),
                                      NSLayoutConstraint(item: cardView, attribute: .bottom, relatedBy: .equal,
                                                         toItem: self.cardView, attribute: .bottom, multiplier: 1.0,
                                                         constant: 0.0),
                                      NSLayoutConstraint(item: cardView, attribute: .trailing, relatedBy: .equal,
                                                         toItem: self.cardView, attribute: .trailing, multiplier: 1.0,
                                                         constant: 0.0),
                                      NSLayoutConstraint(item: cardView, attribute: .leading, relatedBy: .equal,
                                                         toItem: self.cardView, attribute: .leading, multiplier: 1.0,
                                                         constant: 0.0)])

        self.descriptionLabel.text = description

        // Shadow
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOpacity = 0.2
        self.view.layer.shadowOffset = CGSize.zero
        self.view.layer.shadowRadius = 10.0
        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale

        // Corner Radius
        self.view.layer.cornerRadius = 10.0
        self.container?.layer.cornerRadius = 10.0
    }

}
