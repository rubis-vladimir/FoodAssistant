//
//  MainTabBarRouter.swift
//  LifeScreen
//
//  Created by Владимир Рубис on 17.08.2022.
//

import UIKit

/// Протокол управления слоя навигации модуля MainTabBar
protocol MainTabBarRoutable {
    
    /// Переход к AddEventVC
    func routeToAddEvent()
}

/// Слой навигации модуля MainTabBar
final class MainTabBarRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - MainTabBarRoutable
extension MainTabBarRouter: MainTabBarRoutable {
    
    func routeToAddEvent() {
        let vc = BasketAssembly(navigationController: navigationController).assembly()
        
        navigationController.createCustomTransition(with: .moveIn)
        
        navigationController.pushViewController(vc, animated: false)
    }
}
