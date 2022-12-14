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
        /// Устанавливаем зависимости и настраиваем TabBarController
        let tabBarConfigurator = TabBarConfigurator(navigationController: navigationVC)
        let tabBarController = MainTabBarAssembly(navigationController: navigationVC, tabBarConfigurator: tabBarConfigurator).assembly()
        navigationVC.viewControllers = [tabBarController]
        
        /// Определяем rootVC и отображаем на экране
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // Настраиваем свойства по дефолту в приложении
    private func setupElementAppearence() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor = .white
        UITableView.appearance().tableHeaderView = .init(frame: CGRect(x: 0, y: 0, width: 0, height: CGFLOAT_MIN))
    }
}

