//
//  DetailInfoRouter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Навигация в модуле
enum DetailInfoTarget {
    /// Добавление элемента
    case addElement
    /// Детальная информация
    case detailInfo
}

/// Протокол управления слоем навигации модуля
protocol DetailInfoRouting {
    /// Переход к следующему экрану
    ///  - Parameter to: вариант перехода
    func route(to: DetailInfoTarget)
}

/// Слой навигации модуля
final class DetailInfoRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Routing
extension DetailInfoRouter: DetailInfoRouting {
    func route(to: DetailInfoTarget) {
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