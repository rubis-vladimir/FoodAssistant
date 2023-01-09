//
//  LaunchRouter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля Launch
final class LaunchRouter {
    weak var view: UIViewController?
}

// MARK: - LaunchRouting
extension LaunchRouter: LaunchRouting {
    func routeToMainScreen() {
        guard let view = view else { return }
        /// Создаем NavigationController для TabBarController
        let navigationVC = UINavigationController()
        
        /// Устанавливаем зависимости и настраиваем TabBarController
        let tabBarConfigurator = TabBarConfigurator(navigationController: navigationVC)
        let tabBarController = MainTabBarAssembly(navigationController: navigationVC,
                                                  tabBarConfigurator: tabBarConfigurator).assembly()
    
        navigationVC.viewControllers = [tabBarController]
        
        navigationVC.modalPresentationStyle = .fullScreen
//        view.present(navigationVC, animated: true)
        
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = navigationVC
            
        }
    }
}
