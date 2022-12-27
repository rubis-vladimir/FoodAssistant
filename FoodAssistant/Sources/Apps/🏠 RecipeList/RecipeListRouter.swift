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
    
    func routeToDetail(model: RecipeProtocol) {
        guard let navigationController = navigationController else { return }
        let vc = DetailInfoAssembly(navigationController: navigationController, model: model).assembly()
        vc.hidesBottomBarWhenPushed = true
        navigationController.navigationBar.isTranslucent = true
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func routeTest(search: UISearchController) {
        guard let navigationController = navigationController else { return }
        let filterViewController = RecipeFilterAssembly(navigationController: navigationController).assembly()
        filterViewController.hidesBottomBarWhenPushed = true
//        navigationController.navigationBar.isTranslucent = true
        filterViewController.navigationItem.searchController = search
        filterViewController.navigationItem.hidesBackButton = true
        filterViewController.navigationItem.title = "Фильтр"
        filterViewController.navigationController?.navigationBar.backgroundColor = .clear
        navigationController.createCustomTransition(with: .fade)
        navigationController.pushViewController(filterViewController, animated: false)
    }
}
