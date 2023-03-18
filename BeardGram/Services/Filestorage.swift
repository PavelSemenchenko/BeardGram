//
//  Filestorage.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

protocol FileStorageService {
    func upload(image: URL, currentUserId: String, recipientId: String, pictureId: String,
                completion: @escaping (String?) -> Void)
}

class FirebaseFileStorageService: FileStorageService {
    func upload(image: URL, currentUserId: String, recipientId: String, pictureId: String,
                completion: @escaping (String?) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("Need to be authenticated")
        }
        
        let storage = Storage.storage()
        let ref = storage.reference()
        
        // Путь где хранить файлы
        // жуно currentUserId, recipientId, uidPicture
        let photoRef = ref.child("users/\(currentUserId)/dialogs/\(recipientId)/messages/\(pictureId).jpg")
        
        /*
        Firestore.firestore().collection("profiles").document(currentUserId)
                                  .collection("dialogs").document(recipientId)
                                  .collection("messages").addDocument(from: message)
        */
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = photoRef.putFile(from: image, metadata: metadata)
        uploadTask.observe(.success) { snapshot in
            completion(nil)
        }
        uploadTask.observe(.failure) { snapshot in
            completion(snapshot.error?.localizedDescription)
        }
        uploadTask.enqueue()
    }
    
}
