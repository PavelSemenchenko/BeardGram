//
//  Locator.swift
//  BeardGram
//
//  Created by mac on 10.05.2023.
//

import Foundation

class Locator {
    static let profilesRepository: ProfilesRepository = FirebaseProfilesRepository()
    static let authenticationService: AuthenticationService = FirebaseAuthenticationService()
    static let contactsRepository: ContactsRepository = FirebaseContactsRepository()
    static let navigation: NavigationService = NavigationService()
    static let dialogsRepository: DialogsRepository = FirebaseDialogsRepository()
    static let messageRepository: MessagesRepository = FirebaseMessagesRepository()
}
