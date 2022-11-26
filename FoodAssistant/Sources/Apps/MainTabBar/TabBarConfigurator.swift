//
//  TabBarConfigurator.swift
//  LifeScreen
//
//  Created by Владимир Рубис on 27.08.2022.
//

import UIKit

protocol TabBarConfiguration {
    func generate(tabBar: UITabBarController)
}


final class TabBarConfigurator {
    
    /// Настройка TabBar
    /// - Parameter tb: TabBar-VC
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Настройка VC и tabBarItem
    /// - Parameter viewController: Child-VC
    private func setupChildVC(_ viewController: UIViewController,
                              image: UIImage? = nil,
                              selectedImage: UIImage? = nil) -> UIViewController {
        
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }
}

extension TabBarConfigurator: TabBarConfiguration {
    
    func generate(tabBar: UITabBarController) {
        
        let houseImage = Icons.house.image
        let selectedHouseImage = Icons.houseFill.image
        let personImage = UIImage(named: "person")
        let selectedPersonImage = UIImage(named: "person.fill")
        
        let navigationController1 = UINavigationController()
        let recipeListVC = RecipeListAssembly(navigationController: navigationController1).assembly()
        navigationController1.viewControllers = [recipeListVC]
        
        let navigationController2 = UINavigationController()
        let userProfileVC = UserProfileAssembly(navigationController: navigationController).assembly()
        navigationController2.viewControllers = [userProfileVC]
        
        tabBar.viewControllers = [
            setupChildVC(navigationController1,
                         image: houseImage,
                         selectedImage: selectedHouseImage),
            
            UIViewController(),
            
            setupChildVC(navigationController2,
                         image: personImage,
                         selectedImage: selectedPersonImage)
        ]
        
        tabBar.setViewControllers(tabBar.viewControllers, animated: false)
    }
}
