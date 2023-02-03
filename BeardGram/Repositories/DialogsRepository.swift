//
//  DialogsRepository.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 03.02.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Dialog: Codable {
    @DocumentID var id: String?
    let text: String
    let created: Date
    let dialogId: String
    let authorId: String
}

protocol DialogsRepository {
    func getAll(dialogId: String)
    func create(dialogId: String)
    func delete(dialogId: String, id: String)
}
