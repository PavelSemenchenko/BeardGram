//
//  UserRepository.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 31.01.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ContactsRepository {
    func getAll(completion: @escaping ([Profile]) -> Void)
    func append(profile: Profile) -> Profile
    func delete(contactId: String)
    func update(value: Profile)
    func search(name: String, completion: @escaping ([Profile]) -> Void)
}

class FirebaseContactsRepository: ContactsRepository {
    
    func append(profile: Profile) -> Profile {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let profileId = profile.id else {
            fatalError("no permissions")
        }
       
        try? contactsCollection.document(currentUserId)
            .collection("contacts")
            .document(profileId)
            .setData(from: profile)
        return profile
    }
    
    lazy var contactsCollection: CollectionReference = {
        return Firestore.firestore().collection("profiles")
    }()
       
    func getAll(completion: @escaping ([Profile]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("no permissions")
        }
        contactsCollection.document(currentUserId).collection("contacts").getDocuments { snapshot, _ in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }
            var contacts: [Profile] = []
            for doc in docs {
                guard let contact = try? doc.data(as: Profile.self) else {
                    continue
                }
                contacts.append(contact)
            }
            completion(contacts)
        }
    }
    
    func delete(contactId: String) {
    }
    
    func update(value: Profile) {
    }
    
    func search(name: String, completion: @escaping ([Profile]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("no permissions")
        }
        let query = contactsCollection.document(currentUserId).collection("contacts").whereField("name", isEqualTo: name)
        query.getDocuments { snapshot, _ in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }
            var items: [Profile] = []
            for doc in docs {
                guard let profile = try? doc.data(as: Profile.self) else {
                    continue
                }
                if profile.id != Auth.auth().currentUser?.uid {
                    items.append(profile)
                }
            }
            completion(items)
        }
    }
    
}
