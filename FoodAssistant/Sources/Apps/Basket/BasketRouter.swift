//
//  BasketRouter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Навигация в модуле
enum BasketTarget {
    /// Добавление элемента
    case addElement
    /// Детальная информация
    case detailInfo
}

/// Протокол управления слоем навигации модуля
protocol BasketRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: BasketTarget)
}

/// Слой навигации модуля Basket
final class BasketRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - BasketBasketRouting
extension BasketRouter: BasketRouting {
    func route(to: BasketTarget) {
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
