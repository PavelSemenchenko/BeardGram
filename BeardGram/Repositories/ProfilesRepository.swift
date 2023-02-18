//
//  ProfilesRepository.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.02.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Profile: Codable {
    @DocumentID var id: String?
    let name: String
}

protocol ProfilesRepository {
    func search(name: String, completion: @escaping ([Profile]) -> Void)
    func createProfile(name: String)
    func getProfile(id: String, completion: @escaping (Profile?) -> Void)
}

class FirebaseProfilesRepository: ProfilesRepository {
    func getProfile(id: String, completion: @escaping (Profile?) -> Void) {
        profilesCollection.document(id).getDocument(as: Profile.self, completion: { result in
            completion(try? result.get())
        })
    }
    
    func createProfile(name: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("You need to be authenticated")
        }
        let profile = Profile(name: name)
        try? profilesCollection.document(currentUserId)
            .setData(from: profile)
    }
    
    func search(name: String, completion: @escaping ([Profile]) -> Void) {
        let query = profilesCollection.order(by: "name")
                                      .start(at: [name])
                                      .end(at: ["\(name)\u{f8ff}"])
        //whereField("name", isEqualTo: name)
        
        query.getDocuments { snapshot, _ in
            guard let docs = snapshot?.documents else {
                completion([])
                return
            }
            var items: [Profile] = []
            for doc in docs {
                guard let profile = try? doc.data(as: Profile.self) else {
                    continue
                }
                if profile.id != Auth.auth().currentUser?.uid {
                    items.append(profile)
                }
            }
            completion(items)
        }
    }
    
    lazy var profilesCollection: CollectionReference = {
        return Firestore.firestore().collection("profiles")
    }()
}
