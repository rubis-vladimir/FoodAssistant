//
//  AppDelegate.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = .white
        
        setupElementAppearence()
        
        /// Создаем NavigationController для TabBarController
        let navigationVC = UINavigationController()
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isUserReady.rawValue) {
            /// Если пользователь уже просматривал экран `Launch`
            /// Устанавливаем зависимости и настраиваем TabBarController
            let tabBarConfigurator = TabBarConfigurator(navigationController: navigationVC)
            let tabBarController = MainTabBarAssembly(navigationController: navigationVC, tabBarConfigurator: tabBarConfigurator).assembly()
            navigationVC.viewControllers = [tabBarController]
            window?.rootViewController = navigationVC
        } else {
            /// Если нет - настраиваем модуль `Launch`
            let viewController = LaunchAssembly().assembly()
            window?.rootViewController = viewController
        }
        
        /// Определяем rootVC и отображаем на экране
        
        window?.makeKeyAndVisible()
        return true
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
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
    }
}

