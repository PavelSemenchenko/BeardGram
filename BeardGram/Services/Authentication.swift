//
//  Authentication.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import FirebaseAuth
import CryptoKit

protocol AuthenticationService {
    func signUp(email: String, password: String, completion: @escaping (String?) -> Void)
    func signIn(email: String, password: String, comptetion: @escaping (String?) -> Void)
    func signInWithApple(token: String, nonce: String, completion: @escaping (Bool, String?) -> Void)
    func signInWithFacebook(token: String, nonce: String, completion: @escaping (Bool, String?) -> Void)
    func isAuthenticated() -> Bool
    func logOut()
    
    
}

class FirebaseAuthenticationService: AuthenticationService {
    func signIn(email: String, password: String, comptetion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if result?.user != nil {
                comptetion(nil)
            } else {
                let message = error?.localizedDescription
                comptetion(message)
            }
        }
    }
    
    func signInWithFacebook(token: String, nonce: String, completion: @escaping (Bool, String?) -> Void) {
        // let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        let credential = OAuthProvider.credential(withProviderID: "facebook.com",
                                                  idToken: token,
                                                  rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            let isNewUser = authResult?.additionalUserInfo?.isNewUser ?? false
            completion(isNewUser, error?.localizedDescription)
        }
    }
    
    func signInWithApple(token: String, nonce: String, completion: @escaping (Bool, String?) -> Void) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: token,
                                                  rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            let isNewUser = authResult?.additionalUserInfo?.isNewUser ?? false
            completion(isNewUser, error?.localizedDescription)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if result?.user != nil {
                completion(nil)
            } else {
                let message = error?.localizedDescription
                completion(message)
            }
        }
    }
    
    func isAuthenticated() -> Bool {
        let hasUser = Auth.auth().currentUser != nil
        return hasUser
    }
    
    func logOut() {
        try? Auth.auth().signOut()
    }
    
    class func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    @available(iOS 13, *)
    class func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
