//
//  SVLoginManager.swift
//  Survyy
//
//  Created by Guillermo Delgado on 03/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import Firebase

class SVLoginManager: NSObject {

    static let shared = SVLoginManager()
    var ref: DatabaseReference! = Database.database().reference()

    private override init() { }

    public func isUserAuthorized() -> Bool {
        return Auth.auth().currentUser != nil
    }

    public func signUp(_ email: String,
                       password: String,
                       completion: FirebaseAuth.AuthResultCallback? = nil) {

        let hud = SVProgressHUD.init(WithCustomHudInTopViewWithText: "Signing in...")
        DispatchQueue.global(qos: .background).async {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    let userRef = self.ref.child("users").child((Auth.auth().currentUser?.uid)!)
                    userRef.setValue(["email": email])
                    if user != nil {
                        let changeRequest = user?.createProfileChangeRequest()
                        changeRequest?.commitChanges(completion: nil)
                    }
                }

                if completion != nil {
                    completion!(user, error)

                    DispatchQueue.main.async {
                        hud.hide()
                    }
                }
            })
        }
    }

    public func signIn(withEmail email: String,
                       password: String,
                       completion: FirebaseAuth.AuthResultCallback? = nil) {

        let hud = SVProgressHUD.init(WithCustomHudInTopViewWithText: "Logging in...")
        DispatchQueue.global(qos: .background).async {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if completion != nil {
                    completion!(user, error)

                    DispatchQueue.main.async {
                        hud.hide()
                    }
                }
            })
        }
    }

    public func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print ("Error signing out: %@", error)
        }
    }
}
