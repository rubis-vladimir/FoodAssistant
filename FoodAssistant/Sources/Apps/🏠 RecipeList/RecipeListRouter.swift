//
//  RecipeListRouter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля RecipeList
final class RecipeListRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - RecipeListRouting
extension RecipeListRouter: RecipeListRouting {
    func routeToFilter(_ flag: Bool,
                       search: UISearchController,
                       searchDelegate: SeachRecipesRequested) {
        guard let navigationController = navigationController else { return }
        
        if flag {
            let filterViewController = RecipeFilterAssembly(navigationController: navigationController,
                                                            searchDelegate: searchDelegate).assembly()
            
            filterViewController.navigationItem.searchController = search
            filterViewController.navigationItem.hidesBackButton = true
            filterViewController.navigationItem.title = "Фильтр"
            filterViewController.navigationController?.navigationBar.backgroundColor = .clear
            navigationController.createCustomTransition(with: .fade)
            navigationController.navigationBar.isTranslucent = true
            navigationController.pushViewController(filterViewController, animated: false)
        } else {
//            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationItem.hidesSearchBarWhenScrolling = false
            navigationController.hidesBottomBarWhenPushed = false
            navigationController.popViewController(animated: true)
        }
    }
    
    
    func routeToDetail(model: RecipeProtocol) {
        guard let navigationController = navigationController else { return }
        let vc = DetailInfoAssembly(navigationController: navigationController,
                                    recipe: model).assembly()
        vc.hidesBottomBarWhenPushed = true
        navigationController.navigationBar.isTranslucent = true
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func routeTest(search: UISearchController,
                   searchDelegate: SeachRecipesRequested) {
        
    }
}
