//
//  SVTableViewCell.swift
//  Survyy
//
//  Created by Guillermo Delgado on 09/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var avatarView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var avatar: UIView = UIView() {
        didSet {
            self.avatarView.addSubview(avatar)
            avatar.frame = CGRect(x:0, y:0, width:self.avatarView.frame.width, height: self.avatarView.frame.height)
            avatar.contentMode = .scaleAspectFill
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

    override func awakeFromNib() {
        super.awakeFromNib()

        self.containerView.layer.cornerRadius = 4.0
        self.containerView.subviews.first?.layer.cornerRadius = 4.0

        self.avatarView.layer.cornerRadius = self.avatarView.frame.width / 2
        self.avatarView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
