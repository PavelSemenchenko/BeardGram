//
//  WellcomeVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import UIKit
import AuthenticationServices
import FBSDKLoginKit

class WellcomeVC: UIViewController {
    lazy var authenticationService: AuthenticationService = Locator.L.authenticationService
    lazy var navigation: NavigationService = Locator.L.navigation
    
    fileprivate var currentNonce: String?
    
    @IBOutlet weak var loginFBView: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            }
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
        
        navigationItem.setHidesBackButton(true, animated: true)
        /*
        let nonce = FirebaseAuthenticationService.randomNonceString()
        currentNonce = nonce
        loginButton.delegate = self
        loginButton.loginTracking = .limited
        loginButton.nonce = FirebaseAuthenticationService.sha256(nonce)
         */
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let signUp = self.storyboard?.instantiateViewController(withIdentifier: "signUP") as? SignUpVC else {
            return
        }
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    @IBAction func enterWithAppleButtonClicked(_ sender: Any) {
        let nonce = FirebaseAuthenticationService.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = FirebaseAuthenticationService.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        // authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func enterWithFacebookButtonClicked(_ sender: Any) {
        let loginButton = FBLoginButton()
        let nonce = FirebaseAuthenticationService.randomNonceString()
            currentNonce = nonce
            loginButton.delegate = self
            loginButton.loginTracking = .limited
        loginButton.nonce = FirebaseAuthenticationService.sha256(nonce)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let signUp = self.storyboard?
            .instantiateViewController(withIdentifier: "signInSB") as? SignInVC else {
            return
        }
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
}
// делегат для apple
extension WellcomeVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            authenticationService.signInWithApple(token: idTokenString, nonce: nonce) { newUser, error in
                if newUser {
                    // скрин после получения имейла и имени
                } else {
                    // если не новый пользователь - go Home
                    
//                    не открывает -падает на пользователях!
//                    navigation.openHome(self)
                    NavigationService().openHome(self)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension WellcomeVC: LoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton,
                     didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?,
                     error: Error?) {
        if let result = result {
            guard let tokenString = result.token?.tokenString else {
                print("Unable to fetch identity token")
                return
            }
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            authenticationService.signInWithFacebook(token: tokenString, nonce: nonce) { newUser, error in
                if newUser {
                   // идем дополнять инфу о пользователе
                } else {
                    guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeSB") as? HomeVC else {
                        return
                    }
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
    }
}
@IBDesignable
public class GradientWellcome: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
}
