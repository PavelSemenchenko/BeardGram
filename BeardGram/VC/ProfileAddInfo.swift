//
//  ProfileAddInfo.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.02.2023.
//

import Foundation
import UIKit

class ProfileAddInfo: UIViewController {
    
    let profilesRepository: ProfilesRepository = FirebaseProfilesRepository()
    
    func onContinue(){
        profilesRepository.createProfile(name: "Paule")
    }
}
