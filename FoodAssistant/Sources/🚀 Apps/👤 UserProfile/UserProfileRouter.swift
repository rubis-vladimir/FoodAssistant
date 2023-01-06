//
//  UserProfileRouter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля UserProfile
final class UserProfileRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

// MARK: - UserProfileRouting
extension UserProfileRouter: UserProfileRouting {
    func route(to: UserProfileTarget) {
        switch to {
        case .detailInfo(let recipe):
            guard let navigationController = navigationController else { return }
            let vc = DetailInfoAssembly(navigationController: navigationController,
                                        recipe: recipe).assembly()
            vc.hidesBottomBarWhenPushed = true
            navigationController.navigationBar.isTranslucent = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
