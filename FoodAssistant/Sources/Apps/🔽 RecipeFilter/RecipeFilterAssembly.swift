//
//  RecipeFilterAssembly.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Компоновщик модуля
final class RecipeFilterAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension RecipeFilterAssembly: Assemblying {
    func assembly() -> UIViewController {
        
        let filterManager = FilterManager()
        
        let router = RecipeFilterRouter(navigationController: navigationController)
        let interactor = RecipeFilterInteractor(filterManager: filterManager)
        let presenter = RecipeFilterPresenter(interactor: interactor,
                                  router: router)
        let viewController = RecipeFilterViewController(presenter: presenter)
        presenter.view = viewController
        interactor.presenter = presenter
        
        presenter.getStartData()
        return viewController
    }
}

