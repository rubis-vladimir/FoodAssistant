//
//  RecipeFilterRouter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Слой навигации модуля RecipeFilter
final class RecipeFilterRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - RecipeFilterRouting
extension RecipeFilterRouter: RecipeFilterRouting {
    func routeToBack() {
        
    }
}
