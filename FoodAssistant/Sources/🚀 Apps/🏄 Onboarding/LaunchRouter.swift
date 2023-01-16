//
//  LaunchRouter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля Launch
final class LaunchRouter {}

// MARK: - LaunchRouting
extension LaunchRouter: LaunchRouting {
    func routeToMainScreen() {
        /// Создаем NavigationController для TabBarController
        let navigationVC = UINavigationController()

        /// Устанавливаем зависимости и настраиваем TabBarController
        let tabBarConfigurator = TabBarConfigurator(navigationController: navigationVC)
        let tabBarController = MainTabBarAssembly(navigationController: navigationVC,
                                                  tabBarConfigurator: tabBarConfigurator).assembly()

        navigationVC.viewControllers = [tabBarController]
        navigationVC.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = navigationVC
        }
    }
}
