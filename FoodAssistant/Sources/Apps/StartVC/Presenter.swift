//
//  Presenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации
protocol Presentation {
    func testTranslate()
    
    func testGetRandom()
    func testGetRecipe()
}

/// Протокол делегата бизнес логики
protocol BusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля
final class Presenter {
    weak var delegate: Viewable?
    private let interactor: BusinessLogic
    private let router: Routing
    
    init(interactor: BusinessLogic,
         router: Routing) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Presentation
extension Presenter: Presentation {
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
extension Presenter: BusinessLogicDelegate {
    
}
