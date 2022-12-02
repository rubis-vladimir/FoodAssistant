//
//  MainTabBarAssembly.swift
//  LifeScreen
//
//  Created by Владимир Рубис on 17.08.2022.
//

import UIKit

/// #Компоновщик VIPER-модуля MainTabBar
final class MainTabBarAssembly {
    
    private let navigationController: UINavigationController
    private let tabBarConfigurator: TabBarConfiguration
    
    init(navigationController: UINavigationController,
         tabBarConfigurator: TabBarConfiguration) {
        self.navigationController = navigationController
        self.tabBarConfigurator = tabBarConfigurator
        
        /// Скрываю navBar для tabBar
        navigationController.navigationBar.isHidden = true
    }
}

// MARK: - Assemblying
extension MainTabBarAssembly: Assemblying {
    
    func assembly() -> UIViewController {
        let router = MainTabBarRouter(navigationController: navigationController)
        let presenter = MainTabBarPresenter(router: router)
        let tb = MainTabBarController(presenter: presenter)
        tabBarConfigurator.generate(tabBar: tb)
        return tb
    }
}



