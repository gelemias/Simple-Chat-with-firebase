//
//  SVBusinessItem.swift
//  Survyy
//
//  Created by Guillermo Delgado on 11/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import CoreLocation

class SVBusinessItem: NSObject {

    private(set) var name: String!
    private(set) var information: String!
    private(set) var avatar: UIImageView!
    private(set) var location: CLLocation!

    init(name: String, information: String, avatar: UIImageView, location: CLLocation) {
        self.name = name
        self.information = information
        self.avatar = avatar
        self.location = location
    }
}
