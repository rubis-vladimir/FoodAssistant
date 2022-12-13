//
//  UserProfileRouter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля
final class UserProfileRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - UserProfileRouting
extension UserProfileRouter: UserProfileRouting {
    func route(to: UserProfileTarget, model: RecipeProtocol) {
        switch to {
        case .detailInfo:
            let vc = DetailInfoAssembly(navigationController: navigationController, model: model).assembly()
            vc.hidesBottomBarWhenPushed = true
            navigationController.navigationBar.isTranslucent = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
