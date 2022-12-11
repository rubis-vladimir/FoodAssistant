//
//  Router.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Навигация в модуле RecipeList
enum RecipeListTarget {
    /// Детальная информация
    case detailInfo
}

/// #Протокол управления слоем навигации модуля RecipeList
protocol RecipeListRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: RecipeListTarget, model: RecipeProtocol)
}

/// #Слой навигации модуля
final class RecipeListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - RecipeListRouting
extension RecipeListRouter: RecipeListRouting {
    func route(to: RecipeListTarget, model: RecipeProtocol) {
        switch to {
        case .detailInfo:
            let vc = DetailInfoAssembly(navigationController: navigationController, model: model).assembly()
            vc.hidesBottomBarWhenPushed = true
            navigationController.navigationBar.isTranslucent = true
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
