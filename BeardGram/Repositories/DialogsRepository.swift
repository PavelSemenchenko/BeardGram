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
    @DocumentID var id: String?
    let title: String
    @ServerTimestamp var created: Date?
    let authorId: String
}

protocol DialogsRepository {
    func getAll(/*userId: Int,*/ completion: @escaping ([Dialog]) -> Void)
    func create(title: String) -> Dialog
    func delete(dialogId: String)
    func update(value: Dialog)
}

class FirebaseDialogsRepository: DialogsRepository {
    func getAll(completion: @escaping ([Dialog]) -> Void) {
        dialogsCollection.getDocuments { snapshot, _ in
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
    
    func create(title: String) -> Dialog {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("need authenticate")
        }
        var dialog = Dialog(title: title, authorId: currentUserId)
        guard let reference = try? dialogsCollection.addDocument(from: dialog) else {
            fatalError("failed to create")
        }
        dialog.id = reference.documentID
        return dialog
    }
    
    func delete(dialogId: String) {
        dialogsCollection.document(dialogId).delete()
    }
    
    func update(value: Dialog) {
        guard let documentId = value.id else {
            return
        }
        try? dialogsCollection.document(documentId).setData(from: value)
    }
    
    lazy var dialogsCollection: CollectionReference = {
        return Firestore.firestore().collection("dialogs")
    }()
    
    
}
