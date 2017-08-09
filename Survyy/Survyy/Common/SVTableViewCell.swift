//
//  SVTableViewCell.swift
//  Survyy
//
//  Created by Guillermo Delgado on 09/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.containerView.layer.cornerRadius = 4.0
        self.containerView.subviews.first?.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
