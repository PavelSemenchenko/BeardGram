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

// Создаем генерик тип универсальный 
func snapshotToArray<E>(_ snapshot: QuerySnapshot?) -> [E] where E: Codable {
    // разобрали снепшот - проверили есть ли в нем документы/ если нет
    guard let docs = snapshot?.documents else {
        return [] // вернули пустой массив
    }
    var items: [E] = [] // создали масим елементов Е
    for doc in docs {
        guard let contact = try? doc.data(as: E.self) else {
            continue
        }
        items.append(contact)
    }
    return items
}

struct BGMessage : Codable {
    @DocumentID var id: String?
    let text: String
    @ServerTimestamp fileprivate(set) var created: Date?
    fileprivate(set) var attachments: [BGAttachment]?
}

struct BGAttachment: Codable {
    let ref: String
    let type: String
}

protocol MessagesRepository {
    func getAll(recipientId: String, completion: @escaping ([BGMessage]) -> Void)
    func sendText(message: String, recipientId: String)
    func sendImages(images: [URL], recipientId: String, message: String)
}

class FirebaseMessagesRepository: MessagesRepository {
    
    let photoService: FileStorageService = FirebaseFileStorageService()
    
    func getAll(recipientId: String, completion: @escaping ([BGMessage]) -> Void) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Need to be authenticated")
        }
        
        Firestore.firestore().collection("profiles").document(currentUserId)
            .collection("dialogs").document(recipientId)
            .collection("messages").order(by: "created")
            .addSnapshotListener { snapshot, _ in
                
                let items: [BGMessage] = snapshotToArray(snapshot)
                completion(items)
            }
    }
    
    func sendText(message: String, recipientId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Need to be authenticated")
        }
        let message = BGMessage(text: message)
        sendMessage(message: message, recipientId: recipientId, currentUserId: currentUserId)
    }
    
    func sendImages(images: [URL], recipientId: String, message: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Need to be authorised")
        }
        
        var message = BGMessage(text: message)
        
        var imageURLs: [URL: String] = [:]
        
        let attachments = images.map { fileURL in
            let pictureId = UUID().uuidString
            imageURLs[fileURL] = pictureId
            return BGAttachment(ref: "https://firebasestorage.googleapis.com/v0/b/beardgram-b167e.appspot.com/c/users%2F\(currentUserId)%2Fdialogs%2F\(recipientId)%2F\(pictureId).jpg?alt=media", type: "image")
        }
        
        message.attachments = attachments
        
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
        
        for imageURLPair in imageURLs {
            photoService.upload(image: imageURLPair.key, currentUserId: currentUserId, recipientId: recipientId, pictureId: imageURLPair.value) { error in
                print(error)
            }
        }
    }
    
    private func sendMessage(message: BGMessage, recipientId: String, currentUserId: String) {
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
}
