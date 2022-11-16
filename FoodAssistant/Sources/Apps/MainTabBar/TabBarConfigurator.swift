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
        
        let houseImage = UIImage(named: "house")
        let selectedHouseImage = UIImage(named: "house.fill")
        let personImage = UIImage(named: "person")
        let selectedPersonImage = UIImage(named: "person.fill")
        
        
        let recipeListVC = RecipeListAssembly(navigationController: navigationController).assembly()
//        let navigationController1 = UINavigationController(rootViewController: recipeListVC)
        
        let userProfileVC = UserProfileAssembly(navigationController: navigationController).assembly()
        let navigationController2 = UINavigationController(rootViewController: userProfileVC)
        
        tabBar.viewControllers = [
            setupChildVC(recipeListVC,
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
