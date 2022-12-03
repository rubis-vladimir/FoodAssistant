//
//  MainTabBarRouter.swift
//  LifeScreen
//
//  Created by Владимир Рубис on 17.08.2022.
//

import UIKit	

/// #Протокол управления слоя навигации модуля MainTabBar
protocol MainTabBarRoutable {
    /// Переход к `BasketVC`
    func routeToBasket()
}

/// #Слой навигации модуля MainTabBar
final class MainTabBarRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - MainTabBarRoutable
extension MainTabBarRouter: MainTabBarRoutable {
    
    func routeToBasket() {
        let vc = BasketAssembly(navigationController: navigationController).assembly()
        
        /// Добавляем кастомный переход
        navigationController.createCustomTransition(with: .moveIn)
        navigationController.pushViewController(vc, animated: false)
    }
}
