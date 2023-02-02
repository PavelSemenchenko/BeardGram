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

struct Contact: Codable {
    @DocumentID var id: String?
    let name: String
    // let email: String
    // let authorId: String?
}

protocol ContactsRepository {
    func getAll(completion: @escaping ([Contact]) -> Void)
    func getOne(userId: String, completion: @escaping ([Contact]) -> Void)
    // func create(name: String, email: String) -> Contact
    func delete(contactId: String)
    func update(value: Contact)
}

class FirebaseContactsRepository: ContactsRepository {
    
    lazy var contactsCollection: CollectionReference = {
        return Firestore.firestore().collection("contacts")
    }()
    
    func getOne(userId: String, completion: @escaping ([Contact]) -> Void) {
        
    }
    
    func getAll(completion: @escaping ([Contact]) -> Void) {
        contactsCollection.getDocuments { snapshot, _ in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }
            var contacts: [Contact] = []
            for doc in docs {
                guard let contact = try? doc.data(as: Contact.self) else {
                    continue
                }
                contacts.append(contact)
            }
            completion(contacts)
        }
    }
    
    func delete(contactId: String) {
        
    }
    
    func update(value: Contact) {
        
    }
    
    // let fileStorageService: FileStorageService = FirebaseFileStorageService()
    
    
    
}
