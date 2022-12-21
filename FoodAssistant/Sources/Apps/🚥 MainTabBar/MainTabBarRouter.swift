//
//  MainTabBarRouter.swift
//  FoodAssistant
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
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("DEINIT \(self)")
    }
}

// MARK: - MainTabBarRoutable
extension MainTabBarRouter: MainTabBarRoutable {
    
    func routeToBasket() {
        guard let navigationController = navigationController else {return}
        let vc = BasketAssembly(navigationController: navigationController).assembly()
        
        /// Добавляем кастомный переход
        navigationController.createCustomTransition(with: .moveIn)
        navigationController.pushViewController(vc, animated: false)
    }
}
