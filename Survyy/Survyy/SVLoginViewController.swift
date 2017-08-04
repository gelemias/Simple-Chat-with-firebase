//
//  SVLoginViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 03/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import Canvas

class SVLoginViewController: SVFormBaseViewController {

    private let kRePasswordTopMargin: CGFloat = 10.0
    private let kLogoTopMargin: CGFloat = 0.0
    private let kLogoNavHeight: CGFloat = 50.0

    private var _defaultRePasswordTopMargin: CGFloat!
    private var _defaultLogoHeightConstraint: CGFloat!
    private var _defaultLogoTopConstraint: CGFloat!
    private var _defaultPasswordButtonTrailingConstraint: CGFloat!

    private var _errorsList: [UITextField] = []
    private var _inputFields: [UITextField]!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var logoImgView: UIImageView!

    @IBOutlet weak var rePasswordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rePasswordButtonTrailingConstraint: NSLayoutConstraint!

// MARK: - Lifecicle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.errorLabel.text = ""

        _inputFields = [self.usernameTextField, self.passwordTextField, self.rePasswordTextField]

        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.rePasswordTextField.delegate = self

        _defaultLogoHeightConstraint = self.logoHeightConstraint.constant
        _defaultLogoTopConstraint = self.logoTopConstraint.constant
        _defaultPasswordButtonTrailingConstraint = self.passwordButtonTrailingConstraint.constant
        _defaultRePasswordTopMargin = self.rePasswordTopConstraint.constant

        self.rePasswordTextField.superview?.alpha = 0
        self.backButton.isHidden = true

        self.rePasswordTopConstraint.constant = _defaultRePasswordTopMargin
    }

    override func viewDidAppear(_ animated: Bool) {
        self.doBack(nil)
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        if SVLoginManager.shared.isUserAuthorized() {
            self.dismiss(animated: true, completion: nil)
        }

        if UIDevice.current.userInterfaceIdiom == .phone {

            if self.isWithinScreenThreshold() {
                self.logoHeightConstraint.constant = kLogoNavHeight
                self.logoTopConstraint.constant = kLogoTopMargin
            }

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                                   name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                                   name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }

        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {

        if UIDevice.current.userInterfaceIdiom == .phone {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }

        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToSignUpSegue" {
//            PBSignUpViewController *signupVC = [segue destinationViewController]
//            [signupVC addUsername:self.usernameTextField.text
//                andPassword:self.passwordTextField.text]
        }
    }

// MARK: - Keyboard methods

    func keyboardWillShow(_ notification: NSNotification!) {

        var fieldFocused: UITextField!

        for field: UITextField in _inputFields where field.isFirstResponder {
            fieldFocused = field
        }

        if self.isWithinScreenThreshold() {
            self.logoTopConstraint.constant = -(fieldFocused.frame.height * CGFloat((_inputFields.index(of: fieldFocused)! + 1)))
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()

            for f: UITextField in self._inputFields {
                f.superview?.superview?.alpha = f == fieldFocused ? 1 : 0.5
            }

            self.backButton.alpha = 0
            self.signupButton.alpha = 0
            self.forgotPasswordButton.alpha = 0

        }) { (_) in
            self.backButton.isHidden = true
        }
    }

    func keyboardWillHide(_ notification: NSNotification!) {

        if self.isWithinScreenThreshold() {
            self.logoTopConstraint.constant = kLogoTopMargin
        }

        if self.isInSignUpView() {
            self.backButton.isHidden = false
        }

        UIView.animate(withDuration: 0.2) {

            self.view.layoutIfNeeded()

            self.backButton.alpha = 1
            self.signupButton.alpha = 1
            self.forgotPasswordButton.alpha = 1

            for f: UITextField in self._inputFields {
                f.superview?.superview?.alpha = 1
            }
        }
    }

// MARK: - UITextField Delegate

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if self.isInSignUpView() {
            self.rePasswordButtonTrailingConstraint.constant = _defaultPasswordButtonTrailingConstraint
        } else {
            self.passwordButtonTrailingConstraint.constant = _defaultPasswordButtonTrailingConstraint
        }

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.usernameTextField {
            textField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {

            if self.isInSignUpView() {
                textField.resignFirstResponder()
                self.rePasswordTextField.becomeFirstResponder()
            } else {
                for field: UITextField in _inputFields {
                    if !self.validateTextfield(field) {
                        return false
                    }
                }

                self.doLogin(nil)
            }
        } else if textField == self.rePasswordTextField {
            for field: UITextField in _inputFields where self.validateTextfield(field) == false {
                return false
            }
            
            self.doContinueWithRegistration(nil)
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !(string == " ")
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        let animation: CAAnimationGroup = self.animationForBorder(WithFrom: 0, widthTo: kBorderWidth,
                                                                  colorFrom: UIColor.clear, colorTo: UIColor.blue,
                                                                  duration: 0.5)
        let layer = textField.superview?.superview?.layer

        layer?.add(animation, forKey:"color and width")
        layer?.borderWidth = CGFloat(kBorderWidth)
        layer?.borderColor = UIColor.blue.cgColor

        if _errorsList.count == 0 || _errorsList.count == 1 && _errorsList.contains(textField) {
            self.showErrorMessage(show: false)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        textField.text = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        for i in 0..._inputFields.index(of: textField)! {
            _ = self.validateTextfield(_inputFields[i])
        }
    }

// MARK: - Actions

    @IBAction func doLogin(_ sender: UIButton?) {

        self.animateButton(btn: sender!)

        SVLoginManager.shared.signIn(withEmail: self.usernameTextField.text!,
                                     password: self.rePasswordTextField.text!,
                                     completion: { (_, error) in
                                        if error != nil {
                                            let alert = UIAlertController(title: "Sign up failed",
                                                                          message: error?.localizedDescription,
                                                                          preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        } else {
                                            print("signIn - SUCCESS")
                                            self.dismiss(animated: false, completion: nil)
                                        }
        })
    }

    @IBAction func doSignUp(_ sender: UIButton?) {

        self.clearAllTextfields()
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.rePasswordTextField.resignFirstResponder()

        self.rePasswordTopConstraint.constant = kRePasswordTopMargin
        self.backButton.isHidden = false

        if UIDevice.current.userInterfaceIdiom == .phone {
            self.logoTopConstraint.constant = kLogoTopMargin
            self.logoHeightConstraint.constant = kLogoNavHeight
        }

        UIView.animate(withDuration: 0.6, animations: {
            self.view.layoutIfNeeded()
            self.rePasswordTextField.superview?.alpha = 1
            self.backButton.alpha = 1

            self.signupButton.alpha = 0
            self.forgotPasswordButton.alpha = 0
        }) { (_) in
            self.signupButton.isHidden = true
            self.forgotPasswordButton.isHidden = true
        }
    }

    @IBAction func doContinueWithRegistration(_ sender: UIButton?) {

        self.animateButton(btn: sender)

        var isValid: Bool = true

        for field: UITextField in _inputFields where !self.validateTextfield(field) {
            isValid = false
            break
        }

        if isValid {

            self.dismissKeyboard()

            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let signupvc = storyboard.instantiateViewController(withIdentifier: "SVSignUpViewController") as? SVSignUpViewController else {
                return
            }

//            [signupvc addUsername:self.usernameTextField.text andPassword:self.passwordTextField.text];

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {

                let transition = CATransition.init()
                transition.duration = CFTimeInterval(1.0)
                transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromBottom
                self.view.window?.layer.add(transition, forKey:nil)
                self.present(signupvc, animated: false, completion: nil)
            })
        }
    }

    @IBAction func doBack(_ sender: UIButton?) {

        self.animateButton(btn: sender)
        self.clearAllTextfields()

        self.rePasswordTopConstraint.constant = _defaultRePasswordTopMargin

        guard let btn: UIButton = sender else {
            return
        }

        if UIDevice.current.userInterfaceIdiom == .phone && self.isWithinScreenThreshold() {
            self.logoTopConstraint.constant = kLogoTopMargin
            self.logoHeightConstraint.constant = kLogoNavHeight
        } else {
            self.logoTopConstraint.constant = _defaultLogoTopConstraint
            self.logoHeightConstraint.constant = _defaultLogoHeightConstraint
        }

        self.backButton.isHidden = true
        self.signupButton.isHidden = false
        self.forgotPasswordButton.isHidden = false
        self.passwordButtonTrailingConstraint.constant = _defaultPasswordButtonTrailingConstraint
        self.rePasswordButtonTrailingConstraint.constant = _defaultPasswordButtonTrailingConstraint

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.rePasswordTextField.superview?.alpha = 0
            btn.alpha = 0

            self.signupButton.alpha = 1
            self.forgotPasswordButton.alpha = 1
        }) { (_) in
            btn.isHidden = true
        }
    }

// MARK: - Private class helpers

    func isWithinScreenThreshold() -> Bool {
        return UIScreen.main.bounds.height < 500
    }

    func isInSignUpView() -> Bool {
        return self.rePasswordTextField.superview!.alpha == 1
    }

    func validateTextfield(_ textfield: UITextField) -> Bool {
        return true
    }

    func showErrorMessage(show: Bool) {
        if show {

            if self.isInSignUpView() && self.passwordTextField.text != self.rePasswordTextField.text {
                self.errorLabel.text = "Passwords don't match, try again?"
            } else {
                self.errorLabel.text = "Text length too small, try again?"
            }

            for field: UITextField in _errorsList where field.text?.range(of: " ") != nil {
                    self.errorLabel.text = "Fields can't contain spaces!"
            }

            self.errorLabel.alpha = 0

            UIView.animate(withDuration: 0.2, animations: { 
                self.errorLabel.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.errorLabel.alpha = 0
                self.errorLabel.text = ""
            })
        }
    }

    func clearAllTextfields() {

        for field: UITextField in _inputFields {
            field.text = ""

            guard let index = _errorsList.index(of: field) else {
                return
            }

            _errorsList.remove(at:index)
            self.removeTextfieldDecoration(textfield: field)
        }

        self.showErrorMessage(show: false)

        self.passwordButtonTrailingConstraint.constant = _defaultPasswordButtonTrailingConstraint
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    func animateButton(btn: UIButton?) {
        if btn?.superview is CSAnimationView {
            guard let ani: CSAnimationView = btn?.superview as? CSAnimationView else {
                return
            }

            ani.startCanvasAnimation()
        }
    }
}
