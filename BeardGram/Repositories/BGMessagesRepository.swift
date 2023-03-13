//
//  BGMessagesRepository.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 15.02.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BGMessage : Codable {
    @DocumentID var id: String?
    let text: String
    @ServerTimestamp var created: Date?
    fileprivate(set) var image: String = ""
}
protocol MessagesRepository {
    func getAll(repicientId: String, completion: @escaping ([BGMessage]) -> Void)
    func sendText(message: String, recipientId: String)
    func sendImage(image: URL, recipientID: String)
}

class FirebaseMessagesRepository: MessagesRepository {
    
    
    
    func getAll(repicientId: String, completion: @escaping ([BGMessage]) -> Void) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Need to be authenticated")
        }
        
        Firestore.firestore().collection("profiles").document(currentUserId)
                             .collection("dialogs").document(repicientId)
                             .collection("messages").order(by: "created")
                             .addSnapshotListener { snapshot, _ in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }
            var bgMessages: [BGMessage] = []
            for doc in docs {
                guard let contact = try? doc.data(as: BGMessage.self) else {
                    continue
                }
                bgMessages.append(contact)
            }
            completion(bgMessages)
        }
    }
    
    func sendText(message: String, recipientId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Need to be authenticated")
        }
        let message = BGMessage(text: message)
        // add message to self
        try? Firestore.firestore().collection("profiles").document(currentUserId)
                                  .collection("dialogs").document(recipientId)
                                  .collection("messages").addDocument(from: message)
        // add message to recipient
        try? Firestore.firestore().collection("profiles").document(recipientId)
                                  .collection("dialogs").document(currentUserId)
                                  .collection("messages").addDocument(from: message)
        
        let dialog = Dialog(lastMessage: message.text)
        // update dialogs
        try? Firestore.firestore().collection("profiles").document(currentUserId)
                                  .collection("dialogs").document(recipientId).setData(from: dialog)
        
        try? Firestore.firestore().collection("profiles").document(recipientId)
                                  .collection("dialogs").document(currentUserId).setData(from: dialog)
    }
    
    func sendImage(image: URL, recipientID: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Need to be authorised")
        }
        // let image = BGMessage(text: String, image: String) 
    }
}
