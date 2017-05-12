//
//  SVPersistenceManager.swift
//  Survyy
//
//  Created by Guillermo Delgado on 11/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit

final class SVPersistenceManager: NSObject {

    static let shared = SVPersistenceManager()
    private let kUserDefaultKey = "Survyy.UserDefaultKey"
    private var persistenceModel : SVPersistenceModel?
    
    private override init() {
        super.init()
        self.initialize()
    }
    
    private func initialize() {
        let data = UserDefaults.standard.value(forKey: kUserDefaultKey) as? NSData ?? NSData.init()
        self.persistenceModel = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? SVPersistenceModel
     
        if (self.persistenceModel == nil) {
            self.persistenceModel = SVPersistenceModel.init()
            self.setDefaultValues()
        }
    }
    
    private func setDefaultValues() {
        // Fill with default settings values
    }
    
    private func archive() {
        let data: NSData = NSKeyedArchiver.archivedData(withRootObject: self.persistenceModel!) as NSData
        UserDefaults.standard.set(data, forKey: kUserDefaultKey)
    }
    
    // MARK: - Public Properties
    
    public var currentVersion: Float? {
        set {
            self.persistenceModel?.currentVersion = newValue!
            self.archive()
        }
        get {
            return self.persistenceModel?.currentVersion
        }
    }
    
    // MARK: - Public Methods
    
    public func restoreAllDefaultValues() {
        UserDefaults.standard.removeObject(forKey: kUserDefaultKey)
        self.initialize()
    }
    
    public func isNewVersion() -> Bool {
        let newVersion : String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let storedVersion : Float! = self.persistenceModel?.currentVersion
        
        if (Float(newVersion) != storedVersion) {
            self.persistenceModel?.currentVersion = Float(newVersion)!
            return true
        }
        
        return false
    }
}
