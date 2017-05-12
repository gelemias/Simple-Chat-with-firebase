//
//  SVPersistenceModel.swift
//  Survyy
//
//  Created by Guillermo Delgado on 11/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit

internal class SVPersistenceModel: NSObject, NSCoding {
    
    var currentVersion: Float = Float.leastNormalMagnitude
    
    private let kCurrentVersionKey = "survyy.currentVersion"

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.currentVersion = aDecoder.decodeFloat(forKey: kCurrentVersionKey)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.currentVersion, forKey:kCurrentVersionKey)
    }
}
