//
//  LoginVM.swift
//  BeardGram
//
//  Created by mac on 25.05.2023.
//

import Foundation
import UIKit
import Combine

class SomeVC: UIViewController {
    
    private let loginVM = LoginVM()
    private var somethingCancelable : AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        somethingCancelable?.cancel()
        somethingCancelable = nil
    }
    
}

enum LoginError: Error {
    }

class LoginVM {
    fileprivate let invalidEmail$ = CurrentValueSubject<Bool, LoginError>(false)
    fileprivate let invalidPassword$ = CurrentValueSubject<Bool, LoginError>(false)
    fileprivate let loginEnabled$ = CurrentValueSubject<Bool, LoginError>(false)
    
    private(set) var email: String? = nil
    private(set) var password: String? = nil
    
    func updateEmail(value: String?) {
        email = value
        
        if let email = email, email.contains("@") {
            invalidEmail$.send(false)
            let isValidPassword = !invalidPassword$.value
        } else {
            invalidEmail$.send(true)
            loginEnabled$.send(false)
        }
    }
    
    func updatePassword(value: String?) {
        password = value
        
        if let password = password, password.count >= 6 {
            invalidPassword$.send(false)
            let isEmailValid = !invalidEmail$.value
            loginEnabled$.send(isEmailValid)
        } else {
            invalidPassword$.send(true)
            loginEnabled$.send(false)
        }
    }
}
