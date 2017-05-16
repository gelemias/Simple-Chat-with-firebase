//
//  SVLoginManager.swift
//  Survyy
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SVLoginManager: NSObject {
    
    static let shared = SVLoginManager()
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()

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
    
    public func signUp(_ username: String, withEmail email: String, password: String, completion: FirebaseAuth.FIRAuthResultCallback? = nil) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(["username": username,
                                                                                          "email"   : email])
            }
            
            if completion != nil {
                completion!(user, error)
            }
        })
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
