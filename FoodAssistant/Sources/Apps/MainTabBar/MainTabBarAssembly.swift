//
//  MainTabBarAssembly.swift
//  LifeScreen
//
//  Created by Владимир Рубис on 17.08.2022.
//

import UIKit

/// Компоновщик VIPER-модуля MainTabBar
final class MainTabBarAssembly {
    
    private let navigationController: UINavigationController
    private let tabBarConfigurator: TabBarConfiguration
    
    init(navigationController: UINavigationController,
         tabBarConfigurator: TabBarConfiguration) {
        self.navigationController = navigationController
        self.tabBarConfigurator = tabBarConfigurator
    }
}

// MARK: - Assemblying
extension MainTabBarAssembly: Assemblying {
    func assembly() -> UIViewController {
        let tb = MainTabBarController()
        let router = MainTabBarRouter()
        let presenter = MainTabBarPresenter(tabBarController: tb,
                                            router: router)
        
        tb.presenter = presenter
        router.navigationController = navigationController
        tabBarConfigurator.generate(tabBar: tb)
        return tb
    }
    
    
    func assembly(viewController: UIViewController) {
        
    }
}



