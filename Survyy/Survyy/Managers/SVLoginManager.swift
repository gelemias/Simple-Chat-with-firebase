//
//  SVLoginManager.swift
//  Survyy
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit
import FirebaseAuth

class SVLoginManager: NSObject {
    
    static let shared = SVLoginManager()
    private override init() { }
    
    public var username : String? {
        get {
            return FIRAuth.auth()?.currentUser != nil ? FIRAuth.auth()?.currentUser!.displayName : ""
        }
    }

    public var email : String {
        get {
            return FIRAuth.auth()?.currentUser != nil ? (FIRAuth.auth()?.currentUser!.email)! : ""
        }
    }

    public func isUserAuthorized() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
    }
    
    public func signUp(withEmail email: String, password: String, completion: FirebaseAuth.FIRAuthResultCallback? = nil) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: completion)
    }
    
    public func signIn(withEmail email: String, password: String, completion: FirebaseAuth.FIRAuthResultCallback? = nil) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: completion)
    }
    
    public func signOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error as NSError {
            print ("Error signing out: %@", error)

        }
    }
}
