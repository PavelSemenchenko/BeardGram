//
//  Navigation.swift
//  BeardGram
//
//  Created by mac on 08.05.2023.
//

import Foundation
import UIKit

class Navigation {
    func openGlobalSearch(_ host: UIViewController) {
        
        guard let vc = host.createById("globalSearchSB") as? GlobalSearchVC else {
            return
        }
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
