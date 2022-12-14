//
//  RecipeListRouter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля RecipeList
final class RecipeListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - RecipeListRouting
extension RecipeListRouter: RecipeListRouting {
    
    func routeToDetail(model: RecipeProtocol) {
        let vc = DetailInfoAssembly(navigationController: navigationController, model: model).assembly()
        vc.hidesBottomBarWhenPushed = true
        navigationController.navigationBar.isTranslucent = true
        navigationController.pushViewController(vc, animated: true)
    }
}
