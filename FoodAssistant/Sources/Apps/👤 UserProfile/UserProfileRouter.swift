//
//  UserProfileRouter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Навигация в модуле
enum UserProfileTarget {
    /// Детальная информация
    case detailInfo
}

/// Протокол управления слоем навигации модуля
protocol UserProfileRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: UserProfileTarget, model: RecipeProtocol)
}

/// Слой навигации модуля
final class UserProfileRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Routing
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
