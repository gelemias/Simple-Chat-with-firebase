//
//  SVReviewedItem.swift
//  Survyy
//
//  Created by Guillermo Delgado on 11/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import CoreLocation

enum SVReviewState: Int {
    case happy
    case normal
    case bad
    case unknown
}

class SVReviewedItem: SVBusinessItem {

    var reviewState: SVReviewState = .unknown

    init(name: String, information: String, avatar: UIImageView, location: CLLocation, state: SVReviewState) {
        super.init(name: name, information: information, avatar: avatar, location: location)
        self.reviewState = state
    }
}
