//
//  SVTableViewCell.swift
//  Survyy
//
//  Created by Guillermo Delgado on 09/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVTableViewCell: UITableViewCell {

    @IBOutlet private weak var edgeView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var avatarView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var avatar: UIView = UIView() {
        didSet {
            self.avatarView.addSubview(avatar)
            avatar.frame = CGRect(x:0, y:0, width:self.avatarView.frame.width, height: self.avatarView.frame.height)
            avatar.contentMode = .scaleAspectFit
        }
    }

    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }

    var subtitle: String = "" {
        didSet {
            self.descriptionLabel.text = subtitle
        }
    }

    var reviewState: SVReviewState = .unknown {
        didSet {

            var color = UIColor.clear
            var width: CGFloat = 2.0

            switch reviewState {
            case .happy:
                color = UIColor(hex:SVConstants.lightGreen)
            case .normal: 
                color = UIColor(hex:SVConstants.lightYellow)
            case .bad:
                color = UIColor(hex:SVConstants.lightRed)
            default:
                    width = 0.0
                    color = UIColor.clear
            }

            self.avatarView.layer.borderWidth = width
            self.avatarView.layer.borderColor = color.cgColor

            if reviewState != .unknown {
                let v = UIView(frame:CGRect(x:0, y:0, width:self.avatarView.frame.width, height: self.avatarView.frame.height))
                v.backgroundColor = color
                v.alpha = 0.6
                self.avatarView.addSubview(v)
            }
        }
    }

    override func draw(_ rect: CGRect) {
        self.avatarView.layer.cornerRadius = self.avatarView.frame.width / 2
        self.avatarView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            UIView.animate(withDuration: 0.2, animations: {
                self.containerView.backgroundColor = UIColor(hex:SVConstants.lightGrey)
                self.containerView.alpha = 0.6
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.containerView.backgroundColor = UIColor.white
                    self.containerView.alpha = 1.0
                })
            }
        }
    }
}
