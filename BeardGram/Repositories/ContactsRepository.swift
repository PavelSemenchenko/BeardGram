//
//  UserRepository.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 31.01.2023.
//

import Foundation
// import Alamofire
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContactProfile: Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
}

protocol ContactProfilesRepository {
    func getAll()
    func getOne(userId: String, completion: @escaping (ContactProfile?) -> Void)
    func create(profile: ContactProfile)
    func delete()
}

class FirebaseContactProfilesRepository: ContactProfilesRepository {
    func getAll() {
        <#code#>
    }
    
    func getOne(userId: String, completion: @escaping (ContactProfile?) -> Void) {
        Firestore.firestore().collection("contacts").document(userId).getDocument(as: ContactProfile.self) { snapshot in
            switch(snapshot) {
            case .success(let contact):
                completion(contact)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func create(profile: ContactProfile) {
        var contactProfile = profile
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Only authenticated users")
        }
        contactProfile.id = currentUserId
        try? Firestore.firestore().collection("contacts").document(currentUserId).setData(from: contactProfile)
    }
    
    func delete() {
        <#code#>
    }
    
    
}
