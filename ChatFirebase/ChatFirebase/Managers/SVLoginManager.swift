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
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()

    private override init() { }

    public var username: String? {
get {
    if FIRAuth.auth()?.currentUser != nil && FIRAuth.auth()?.currentUser!.displayName == nil {
self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in

    let value = snapshot.value as? NSDictionary
    let username = value?["username"] as? String ?? ""
    let user = FIRAuth.auth()?.currentUser!

    let changeRequest = user!.profileChangeRequest()
    changeRequest.displayName = username.capitalized
    changeRequest.commitChanges(completion: nil)
})
    }

    return FIRAuth.auth()?.currentUser != nil ? FIRAuth.auth()?.currentUser!.displayName: ""
}
    }

    public var email: String {
get {
    return FIRAuth.auth()?.currentUser != nil ? (FIRAuth.auth()?.currentUser!.email)!: ""
}
    }

    public func isUserAuthorized() -> Bool {
return FIRAuth.auth()?.currentUser != nil
    }

    public func signUp(_ username: String, withEmail email: String, password: String, completion: FirebaseAuth.FIRAuthResultCallback? = nil) {

SVProgressHUD.show()
DispatchQueue.global(qos: .background).async {
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
if error == nil {
    let rndAvatar: Int = Int(arc4random_uniform(UInt32(7)))
    self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(["username": username.capitalized,
      "email"  : email,
      "avatar" : "avatar" + String(rndAvatar)])
    if user != nil {
let changeRequest = user!.profileChangeRequest()
changeRequest.displayName = username.capitalized
changeRequest.commitChanges(completion: nil)
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

    public func signIn(withEmail email: String, password: String, completion: FirebaseAuth.FIRAuthResultCallback? = nil) {

SVProgressHUD.show()
DispatchQueue.global(qos: .background).async {
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion:  { (user, error) in
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
    try FIRAuth.auth()?.signOut()
} catch let error as NSError {
    print ("Error signing out: %@", error)

}
    }
}
