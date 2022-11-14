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
//        guard let nc = navigationController else { return }
//        let vc = AddEventViewController()
//        
//        AddEventAssembly(navigationController: nc).assembly(viewController: vc,
//                                                            editModel: nil)
//        
//        nc.createCustomTransition(with: .moveIn)
//        
//        nc.pushViewController(vc, animated: false)
    }
}
