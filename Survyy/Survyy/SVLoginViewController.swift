//
//  ViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 11/05/2017.
//  Copyright © 2017 Survyy. All rights reserved.
//

import UIKit

let kTextfieldMargin : CGFloat = 10.0

class SVLoginViewController: UIViewController {
    
    let persistenceManager : SVPersistenceManager! = SVPersistenceManager.shared

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var repeatPasswordTopConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(textFieldDidChanged), name: .UITextFieldTextDidChange, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signInButton.isEnabled = false
    }

    @IBAction func signIn(_ sender: Any) {
        SVLoginManager.shared.signIn(withEmail: self.email.text!, password: self.repeatPassword.text!, completion: { (user, error) in
            if (error != nil) {
                let alert = UIAlertController(title: "Sign up failed", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                print("signIn - SUCCESS")
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func signUp(_ sender: Any) {
        if self.repeatPasswordTopConstraint.constant > kTextfieldMargin {
            if (self.repeatPassword.text == self.password.text) {
                SVLoginManager.shared.signUp(withEmail: self.email.text!, password: self.repeatPassword.text!, completion: { (user, error) in
                    if (error != nil) {
                        let alert = UIAlertController(title: "Sign up failed", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        print("signup - SUCCESS")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                let alert = UIAlertController(title: "Password mismatch", message: "Please type the same password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {
                    self.password.text = ""
                    self.repeatPassword.text = ""
                })
            }
        }
        else {
            self.repeatPasswordTopConstraint.constant = self.password.frame.height + (kTextfieldMargin * 2)
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textFieldDidChanged() {
        self.signInButton.isEnabled = !self.email.text!.isEmpty && !self.repeatPassword.text!.isEmpty
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        self.repeatPasswordTopConstraint.constant = kTextfieldMargin
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

