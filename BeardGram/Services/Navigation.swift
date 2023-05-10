//
//  Navigation.swift
//  BeardGram
//
//  Created by mac on 08.05.2023.
//

import Foundation
import UIKit

class Navigation {
    func openHome(_ scene: SceneDelegate) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "homeSB") as! HomeVC
//            homeViewController.contactsRepository = ContactsDummy()
        homeViewController.contactsRepository = FirebaseContactsRepository()
        homeViewController.authenticationService = FirebaseAuthenticationService()
        homeViewController.navigation = Navigation()
        let navigationViewController = UINavigationController(rootViewController: homeViewController)
        scene.window?.rootViewController = navigationViewController
        scene.window?.makeKeyAndVisible()
    }
    func openHome(_ host: UIViewController) {
        guard let vc = host.createById("homeSB") as? HomeVC else {
            return
        }
//            vc.contactsRepository = ContactsDummy()
        vc.contactsRepository = FirebaseContactsRepository()
        vc.authenticationService = FirebaseAuthenticationService()
        vc.navigation = Navigation()
        host.pushVC(vc)
    }
    func openGlobalSearch(_ host: UIViewController) {
        
        guard let vc = host.createById("globalSearchSB") as? GlobalSearchVC else {
            return
        }
        vc.profilesRepository = FirebaseProfilesRepository()
        vc.navigation = Navigation()
        vc.onAddFriendCompletion = { newFriend in
        }
        
        host.pushVC(vc)
        
    }
    func openConversation(_ host: UIViewController, recipient: String) {
//        регистрируем контроллер
        guard let vc = host.createById("conversationsSB") as? ConversationsVC else {
            return
        }
//        передаем если нужно инфу
        vc.recipientId = recipient
//   выполяем действие перехода
        host.pushVC(vc)
        
    }
    func openRecentMessages(_ host: UIViewController) {
        
        guard let vc = host.createById("recentMessagesSB")
                as? RecentMessagesVC else { return
        }
        host.pushVC(vc)
    }
    func back(_ host: UIViewController) {
        host.navigationController?.popViewController(animated: true)
    }
    func backToRoot(_ host: UIViewController) {
        host.navigationController?.popToRootViewController(animated: true)
    }
}

extension UIViewController {
//    инициализируем контроллер
    fileprivate func createById(_ identifier: String) -> UIViewController? {
        return storyboard?.instantiateViewController(withIdentifier: identifier)
    }
//    действие перехода
    fileprivate func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
