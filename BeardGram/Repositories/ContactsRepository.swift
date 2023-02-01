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

struct Contact: Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let authorId: String?
}

protocol ContactsRepository {
    func getAll(competion: @escaping ([Contact]) -> Void)
    func getOne(userId: String, completion: @escaping ([Contact]) -> Void)
    func create(name: String, email: String) -> Contact
    func delete(contactId: String)
    func update(value: Contact)
}

class FirebaseContactsRepository: ContactsRepository {
    func getOne(userId: String, completion: @escaping ([Contact]) -> Void) {
        <#code#>
    }
    
    func create(name: String, email: String) -> Contact {
        <#code#>
    }
    
    
    func getAll(competion: @escaping ([Contact]) -> Void) {
        contactsT
    }
    
    func delete(contactId: String) {
        <#code#>
    }
    
    func update(value: Contact) {
        <#code#>
    }
    
    // let fileStorageService: FileStorageService = FirebaseFileStorageService()
    
    
    
}
