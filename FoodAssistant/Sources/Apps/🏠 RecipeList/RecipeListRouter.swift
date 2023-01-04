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
            let filterVC = RecipeFilterAssembly(navigationController: navigationController,
                                                searchDelegate: searchDelegate).assembly()
            filterVC.hidesBottomBarWhenPushed = true
            filterVC.navigationItem.searchController = search
            filterVC.navigationController?.navigationBar.backgroundColor = .clear
            
            navigationController.createCustomTransition(with: .fade)
            navigationController.navigationBar.isTranslucent = true
            
            navigationController.pushViewController(filterVC, animated: false)
        } else {
            navigationController.navigationItem.hidesSearchBarWhenScrolling = false
            navigationController.popViewController(animated: true)
        }
    }
    
    func routeToDetail(model: RecipeProtocol) {
        guard let navigationController = navigationController else { return }
        let detailInfoVC = DetailInfoAssembly(navigationController: navigationController,
                                              recipe: model).assembly()
        detailInfoVC.hidesBottomBarWhenPushed = true
        navigationController.navigationBar.isTranslucent = true
        navigationController.pushViewController(detailInfoVC, animated: true)
        
    }
}
