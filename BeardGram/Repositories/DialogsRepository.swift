//
//  DialogsRepository.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 03.02.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Dialog: Codable {
    @DocumentID var userId: String? // recipient Id
    let lastMessage: String
    @ServerTimestamp var lastModified: Date?
}

protocol DialogsRepository {
    func getAll(completion: @escaping ([Dialog]) -> Void)
}

class FirebaseDialogsRepository: DialogsRepository {
    func getAll(completion: @escaping ([Dialog]) -> Void) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("need authenticate")
        }
        
        Firestore.firestore().collection("profiles").document(currentUserId)
                             .collection("dialogs").order(by: "lastModified", descending: true)
                             .addSnapshotListener { snapshot, _ in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }
            var dialogs: [Dialog] = []
            for doc in docs {
                guard let dialog = try? doc.data(as: Dialog.self) else {
                    continue
                }
                dialogs.append(dialog)
            }
            completion(dialogs)
        }
    }
}
