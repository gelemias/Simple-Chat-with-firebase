//
//  SVHomeViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 12/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SVHomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!

    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.updateNameTextField()
    }
    
    func updateNameTextField() {
        self.nameTextfield.delegate = self
        self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.titleLabel.text = value?["username"] as? String ?? FIRAuth.auth()?.currentUser?.email
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        SVLoginManager.shared.signOut()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func send(_ sender: Any) {
        self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).setValue(["username": nameTextfield.text])
        
        self.updateNameTextField()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
