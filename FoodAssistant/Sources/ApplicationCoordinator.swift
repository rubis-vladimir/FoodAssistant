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
    private let userDefaults: UserDefaultsVerifable

    init(window: UIWindow?,
         userDefaults: UserDefaultsVerifable) {
        self.window = window
        self.userDefaults = userDefaults
    }

    func start() {
        setupWindow()
        setupElementAppearence()
    }

    private func setupWindow() {
        window?.backgroundColor = .white

        if userDefaults.checkReady() {
            /// Если пользователь уже просматривал экран `Launch`
            /// Устанавливаем зависимости и настраиваем TabBarController
            let navigationVC = UINavigationController()
            let tabBarConfigurator = TabBarConfigurator(navigationController: navigationVC)
            let tabBarController = MainTabBarAssembly(navigationController: navigationVC,
                                                      tabBarConfigurator: tabBarConfigurator).assembly()
            navigationVC.viewControllers = [tabBarController]
            rootViewController = navigationVC
        } else {
            /// Если нет - настраиваем модуль `Launch`
            let viewController = LaunchAssembly().assembly()
            rootViewController = viewController
        }

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    /// Настраиваем свойства по дефолту в приложении
    private func setupElementAppearence() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = false

        UITableView.appearance().tableHeaderView = .init(frame: CGRect(x: 0, y: 0, width: 0, height: CGFLOAT_MIN))
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel".localize()
    }
}
