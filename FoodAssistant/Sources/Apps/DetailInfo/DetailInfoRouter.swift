//
//  DetailInfoRouter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол управления слоем навигации модуля
protocol DetailInfoRouting {
    /// Возврат назад
    func routeToBack()
}

/// #Слой навигации модуля
final class DetailInfoRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Routing
extension DetailInfoRouter: DetailInfoRouting {
    func routeToBack() {
        navigationController.popViewController(animated: true)
    }
}
