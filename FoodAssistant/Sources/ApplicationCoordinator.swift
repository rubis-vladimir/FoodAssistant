//
//  ApplicationCoordinator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.01.2023.
//

import UIKit

/// #Протокол координатора
protocol Coordinator {
    func start()
}

/// #Координатор приложения
final class ApplicationCoordinator: Coordinator {
    
    private var rootViewController: UIViewController?
    private var window: UIWindow?
    private let userDefaults: UserDefaultsManagement
    
    init(window: UIWindow?,
         userDefaults: UserDefaultsManagement) {
        self.window = window
        self.userDefaults = userDefaults
        
        setup()
    }
    
    func start() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    private func setup() {
        window?.backgroundColor = .white
        
        if userDefaults.checkReady() {
            /// Если пользователь уже просматривал экран `Launch`
            /// Устанавливаем зависимости и настраиваем TabBarController
            let navigationVC = UINavigationController()
            let tabBarConfigurator = TabBarConfigurator(navigationController: navigationVC)
            let tabBarController = MainTabBarAssembly(navigationController: navigationVC, tabBarConfigurator: tabBarConfigurator).assembly()
            navigationVC.viewControllers = [tabBarController]
            rootViewController = navigationVC
        } else {
            /// Если нет - настраиваем модуль `Launch`
            let viewController = LaunchAssembly().assembly()
            rootViewController = viewController
        }
        
        setupElementAppearence()
    }
    
    /// Настраиваем свойства по дефолту в приложении
    private func setupElementAppearence() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
        UITableView.appearance().tableHeaderView = .init(frame: CGRect(x: 0, y: 0, width: 0, height: CGFLOAT_MIN))
        UINavigationBar.appearance().isTranslucent = false
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel".localize()
    }
}
