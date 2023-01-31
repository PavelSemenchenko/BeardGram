//
//  UserRepository.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 31.01.2023.
//

import Foundation
import Alamofire

struct Contact: Codable {
    let id: Int
    let name: String
    let email: String
}

class ContactsRepository {
    func loadAll(completion: @escaping ([Contact]) -> Void) {
        let request = AF.request("link to load from web")
        request.responseDecodable(of: [Contact].self) { contactsResponse in
            completion(contactsResponse.value ?? [])
        }
    }
}
