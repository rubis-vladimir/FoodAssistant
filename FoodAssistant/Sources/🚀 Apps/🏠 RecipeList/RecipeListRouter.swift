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
    
    func routeToFilter(searchDelegate: SeachRecipesRequested) {
        guard let navigationController = navigationController else { return }
        
        let filterVC = RecipeFilterAssembly(navigationController: navigationController,
                                            searchDelegate: searchDelegate).assembly()
        filterVC.hidesBottomBarWhenPushed = true
        navigationController.createCustomTransition(with: .fade)
        navigationController.pushViewController(filterVC, animated: false)
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
