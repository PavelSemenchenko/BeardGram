//
//  SignInVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 30.01.2023.
//

import Foundation
import UIKit

class SignInVC: UIViewController, BaseAuthentication, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    let authenticationService: AuthenticationService = FirebaseAuthenticationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // keyboard Hiding
        registerForKeyboardNotifications()
        
    }
    deinit {
        removeKeyboardNotifications()
    }
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0.0, y: kbFrameSize.height/1.5)
    }
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    
    func signIn(){
        validateFields()
        guard let email = emailTextField.validateEmailTextField(errorLabel: errorEmailLabel) else {
            return
        }
        guard let password = passwordTextField.validatePasswordTextField(errorLabel: errorPasswordLabel) else {
            return
        }
        authenticationService.signIn(email: email, password: password) { errorMessage in
            if let message = errorMessage {
                let alert = UIAlertController(title: "BeardGram", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Hm", style: UIAlertAction.Style.default))
                self.present(alert, animated: true)
            } else {
                guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeSB") as? HomeVC else {
                    return
                }
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        signIn()
    }
    
}
