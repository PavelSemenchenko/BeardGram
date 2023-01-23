//
//  Authentication.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import FirebaseAuth

protocol AuthenticationService {
    func sigUp(name: String, email: String, password: String, completion: @escaping (String?) -> Void)
    func isAuthenticated() -> Bool
    func logOut()
}

class FirebaseAuthenticationService: AuthenticationService {
    func sigUp(name: String, email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                let request = user.createProfileChangeRequest()
                request.displayName = name
                request.commitChanges()
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
    
    
}
