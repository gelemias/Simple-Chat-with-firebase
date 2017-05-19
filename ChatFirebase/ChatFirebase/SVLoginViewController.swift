//
//  ViewController.swift
//  ChatFirebase
//
//  Created by Guillermo Delgado on 11/05/2017.
//  Copyright © 2017 ChatFirebase. All rights reserved.
//

import UIKit

let kTextfieldMargin : CGFloat = 10.0

class SVLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var rePasswordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self
    }

    func signIn() {
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
    
    func createAcount() {
        if (self.repeatPassword.text == self.password.text) {
            SVLoginManager.shared.signUp(self.username.text!, withEmail: self.email.text!, password: self.repeatPassword.text!, completion: { (user, error) in
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
    
    @IBAction func signUp(_ sender: Any) {
        self.emailTopConstraint.constant = self.username.frame.height + (kTextfieldMargin * 2)
        self.rePasswordTopConstraint.constant = self.password.frame.height + (kTextfieldMargin * 2)
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.repeatPassword.placeholder = "Repeat password"
            self.password.alpha = 1
            self.username.alpha = 1
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var proceed : Bool = true
        for subview in view.subviews {
            if subview is UITextField {
                let textField : UITextField = subview as! UITextField
                if textField.alpha == 1 && textField.text!.isEmpty {
                    textField.becomeFirstResponder()
                    proceed = false
                }
            }
        }
        
        if proceed {
            if self.username.alpha == 1 {
                self.createAcount()
            } else {
                self.signIn()
            }
        }

        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        self.rePasswordTopConstraint.constant = kTextfieldMargin
        self.emailTopConstraint.constant = kTextfieldMargin

        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.repeatPassword.placeholder = "Password"
            self.password.alpha = 0
            self.username.alpha = 0
        })
    }
}

