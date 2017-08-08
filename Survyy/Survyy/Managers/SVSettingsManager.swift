//
//  SVSettingsManager.swift
//  Survyy
//
//  Created by Guillermo Delgado on 08/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVSettingsManager: NSObject {

    class var sharedInstance: SVSettingsManager {

        struct Static {
            static let instance: SVSettingsManager = SVSettingsManager()
        }

        return Static.instance
    }

    private var defaultStorage = UserDefaults.standard

    var shouldSkipIntro: Bool {
        get {
            var val = false
            if let storedVal = UserDefaults.standard.value(forKey: SVConstants.shouldSkipIntroKey) as? Bool {
                val = storedVal
            }

            return val

        } set {
            defaultStorage.set(newValue, forKey: SVConstants.shouldSkipIntroKey)
        }
    }

}
