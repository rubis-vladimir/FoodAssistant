//
//  Router.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Навигация в модуле
enum RecipeListTarget {
    /// Добавление элемента
    case addElement
    /// Детальная информация
    case detailInfo
}

/// Протокол управления слоем навигации модуля
protocol RecipeListRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: RecipeListTarget)
}

/// Слой навигации модуля
final class RecipeListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Routing
extension RecipeListRouter: RecipeListRouting {
    func route(to: RecipeListTarget) {
        switch to {
        case .addElement:
            /// Настройка модуля
            let vc = UIViewController()
            /*
             Вызов конфигуратора
             */
            navigationController.pushViewController(vc, animated: true)
        case .detailInfo:
            /// Аналогично
            print("Переход на экран детальной информации")
        }
    }
}
