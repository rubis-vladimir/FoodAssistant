//
//  RecipeFilterAssembly.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Компоновщик модуля RecipeFilter
final class RecipeFilterAssembly {
    private let navigationController: UINavigationController
    private let text: String
    private weak var searchDelegate: SeachRecipesRequested?
    
    init(navigationController: UINavigationController,
         text: String,
         searchDelegate: SeachRecipesRequested?) {
        self.navigationController = navigationController
        self.text = text
        self.searchDelegate = searchDelegate
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
        presenter.rootPresenter = searchDelegate
        interactor.presenter = presenter
        
        presenter.getStartData(text: text)
        return viewController
    }
}

