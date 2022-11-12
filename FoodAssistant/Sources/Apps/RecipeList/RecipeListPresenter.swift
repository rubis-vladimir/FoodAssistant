//
//  Presenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации модуля RecipeList
protocol RecipeListPresentation {
    func testTranslate()
    
    func testGetRandom()
    func testGetRecipe()
}

/// Протокол делегата бизнес логики модуля RecipeList
protocol BusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля RecipeList
final class RecipeListPresenter {
    weak var delegate: RecipeListViewable?
    private let interactor: RecipeListBusinessLogic
    private let router: RecipeListRouting
    
    init(interactor: RecipeListBusinessLogic,
         router: RecipeListRouting) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Presentation
extension RecipeListPresenter: RecipeListPresentation {
    func testTranslate() {
        interactor.translate(texts: ["Hello", "World"])
    }
    
    func testGetRandom() {
        interactor.fetchRandomRecipe(number: 2, tags: ["meal"])
    }
    
    func testGetRecipe() {
        
        var parameters = RecipeFilterParameters()
        parameters.includeIngredients.append(contentsOf: ["onion", "cod"])
        parameters.sort = "random"
        interactor.fetchRecipe(with: parameters, number: 3, query: nil)
    }
}

// MARK: - BusinessLogicDelegate
extension RecipeListPresenter: BusinessLogicDelegate {
    
}
