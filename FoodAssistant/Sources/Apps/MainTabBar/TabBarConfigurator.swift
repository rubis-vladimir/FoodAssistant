//
//  TabBarConfigurator.swift
//  LifeScreen
//
//  Created by Владимир Рубис on 27.08.2022.
//

import UIKit

/// #Протокол конфигурации контроллера панели вкладок
protocol TabBarConfiguration {
    /// Настраивает TabBar и его дочерние VC
    func generate(tabBar: UITabBarController)
}

/// #Конфигуратор TabBar
final class TabBarConfigurator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Настройка tabBarItem
    /// - Parameters:
    ///  - viewController: Child-VC
    ///  - image: изображение
    ///  - selectedImage: изображение при выбранной вкладке
    /// - Returns: Child-VC
    private func setupChildVC(_ viewController: UIViewController,
                              image: UIImage? = nil,
                              selectedImage: UIImage? = nil) -> UIViewController {
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }
}

// MARK: - TabBarConfiguration
extension TabBarConfigurator: TabBarConfiguration {
    
    func generate(tabBar: UITabBarController) {
        /// Конфигурируем модуль для первой вкладки
        let navigationControllerOne = UINavigationController()
        let recipeListVC = RecipeListAssembly(navigationController: navigationControllerOne).assembly()
        navigationControllerOne.viewControllers = [recipeListVC]
        navigationControllerOne.navigationBar.isTranslucent = false
        
        /// Конфигурируем модуль для второй вкладки
        let navigationControllerTwo = UINavigationController()
        let userProfileVC = UserProfileAssembly(navigationController: navigationControllerTwo).assembly()
        navigationControllerTwo.viewControllers = [userProfileVC]
        
        /// Добавляем контроллеры и устанавливаем изображения
        tabBar.viewControllers = [
            setupChildVC(navigationControllerOne,
                         image: Icons.house.image,
                         selectedImage: Icons.houseFill.image),
            
            UIViewController(),
            
            setupChildVC(navigationControllerTwo,
                         image: Icons.person.image,
                         selectedImage: Icons.personFill.image)
        ]
        
        tabBar.setViewControllers(tabBar.viewControllers, animated: false)
    }
}
