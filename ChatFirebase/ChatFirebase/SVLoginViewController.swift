//
//  ViewController.swift
//  ChatFirebase
//
//  Created by Guillermo Delgado on 11/05/2017.
//  Copyright © 2017 ChatFirebase. All rights reserved.
//

import UIKit
import RDGliderViewController_Swift

let kTextfieldMargin: CGFloat = 10.0

class SVLoginViewController: UIViewController, UITextFieldDelegate, SVAvatarPickerViewControllerDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var rePasswordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addAvatarButton: UIButton!

    var avatarPickerGlider: RDGliderViewController?
    var avatar = "avatar" + String(Int(arc4random_uniform(UInt32(7)))) {
        didSet {
            let superV = self.addAvatarButton.superview!

            superV.subviews.forEach {
                if !($0 is UIButton) {
                    $0.removeFromSuperview()
                }
            }

            let avatarImageView: UIImageView = UIImageView(image: UIImage.init(named: self.avatar))
            avatarImageView.frame = CGRect(x: 0, y: 0, width: superV.frame.width, height: superV.frame.height)

            superV.insertSubview(avatarImageView, at: 0)
        }
    }

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

        let content = SVAvatarPickerViewController(length: 300)
        content.delegate = self
        content.cornerRadius = 20.0
        content.showShadow = true
        self.avatarPickerGlider = RDGliderViewController.init(parent: self,
                                                              WithContent: content,
                                                              AndType: .RDScrollViewOrientationBottomToTop,
                                                              WithOffsets: [0, 0.9])
    }

    func signIn() {
        SVLoginManager.shared.signIn(withEmail: self.email.text!,
                                     password: self.repeatPassword.text!,
                                     completion: { (_, error) in
            if error != nil {
                let alert = UIAlertController(title: "Sign up failed",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("signIn - SUCCESS")
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    func createAcount() {
        if self.repeatPassword.text == self.password.text {
            SVLoginManager.shared.signUp(self.username.text!,
                                         withEmail: self.email.text!,
                                         password: self.repeatPassword.text!,
                                         avatar: self.avatar,
                                         completion: { (_, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Sign up failed",
                                                  message: error?.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("signup - SUCCESS")
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            let alert = UIAlertController(title: "Password mismatch",
                                          message: "Please type the same password",
                                          preferredStyle: .alert)
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

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.repeatPassword.placeholder = "Repeat password"
            self.password.alpha = 1
            self.username.alpha = 1
            self.addAvatarButton.alpha = 1
        }, completion:nil)
    }

    @IBAction func addAvatarPressed(_ sender: Any) {
        self.avatarPickerGlider?.expand()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        var proceed: Bool = true

        for subview in view.subviews {
            guard let textField: UITextField = subview as? UITextField else {
                continue
            }

            if textField.alpha == 1 && textField.text!.isEmpty {
                textField.becomeFirstResponder()
                proceed = false
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

        self.addAvatarButton.isHidden = false

        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.repeatPassword.placeholder = "Password"
            self.password.alpha = 0
            self.username.alpha = 0
            self.addAvatarButton.alpha = 0

        })

        self.avatarPickerGlider?.close()
    }

// MARK: - SVAvatarPickerViewControllerDelegate

    func avatarWasPicked(avatar: String) {
        self.avatar = avatar
        self.avatarPickerGlider?.collapse()
    }
}
