//
//  SVLoginManager.swift
//  ChatFirebase
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 ChatFirebase. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SVLoginManager: NSObject {

    static let shared = SVLoginManager()
    var ref: DatabaseReference! = Database.database().reference()

    private override init() { }

    private(set) var username: String? {
        get {
            if Auth.auth().currentUser != nil && Auth.auth().currentUser!.displayName == nil {
                let userRef = self.ref.child("users").child((Auth.auth().currentUser?.uid)!)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in

                    let value = snapshot.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    let user = Auth.auth().currentUser!

                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = username.capitalized
                    changeRequest.commitChanges(completion: nil)
                })
            }

            return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.displayName: ""
        }

        set { }
    }

    private(set) var email: String {
        get {
            return Auth.auth().currentUser != nil ? (Auth.auth().currentUser!.email)!: ""
        }

        set { }
    }

    public func isUserAuthorized() -> Bool {
        return Auth.auth().currentUser != nil
    }

    public func signUp(_ username: String,
                       withEmail email: String,
                       password: String,
                       avatar: String,
                       completion: FirebaseAuth.AuthResultCallback? = nil) {

        SVProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    let userRef = self.ref.child("users").child((Auth.auth().currentUser?.uid)!)
                    userRef.setValue(["username": username.capitalized,
                      "email": email,
                      "avatar": avatar])
                    if user != nil {
                        let changeRequest = user?.createProfileChangeRequest()
                        changeRequest?.displayName = username.capitalized
                        changeRequest?.commitChanges(completion: nil)
                    }
                }

                if completion != nil {
                    completion!(user, error)

                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
            })
        }
    }

    public func signIn(withEmail email: String,
                       password: String,
                       completion: FirebaseAuth.AuthResultCallback? = nil) {

        SVProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if completion != nil {
                completion!(user, error)

                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
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
