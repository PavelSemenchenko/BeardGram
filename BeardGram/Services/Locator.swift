//
//  Locator.swift
//  BeardGram
//
//  Created by mac on 10.05.2023.
//

import Foundation

class Locator {
    fileprivate(set) lazy var profilesRepository: ProfilesRepository = FirebaseProfilesRepository()
    fileprivate(set) lazy var authenticationService: AuthenticationService = FirebaseAuthenticationService()
    fileprivate(set) lazy var contactsRepository: ContactsRepository = FirebaseContactsRepository()
    fileprivate(set) lazy var navigation: NavigationService = NavigationService()
    fileprivate(set) lazy var dialogsRepository: DialogsRepository = FirebaseDialogsRepository()
    fileprivate(set) lazy var messageRepository: MessagesRepository = FirebaseMessagesRepository()
    
    static var L = Locator()
//    сделали локатор защищенным и можем его переопределить заглушкой нижу через поле L
}
