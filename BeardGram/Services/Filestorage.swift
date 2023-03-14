//
//  Filestorage.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 23.01.2023.
//

import Foundation
import FirebaseStorage

protocol FileStorageService {
    func upload(image: URL, completion: @escaping (String?) -> Void)
}

class FirebaseFileStorageService: FileStorageService {
    func upload(image: URL, completion: @escaping (String?) -> Void) {
        let storage = Storage.storage()
        let ref = storage.reference()
        
        // Путь где хранить файлы
        let photoRef = ref.child("путь где хранить фото")
        
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
