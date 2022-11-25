//
//  Presenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации модуля RecipeList
protocol RecipeListPresentation: RLLayoutChangable, RLRecipeButtonDelegate, AnyObject {
    var viewModels: [RecipeCellModel] { get }
    func testTranslate()
    
    func testGetRandom()
    func testGetRecipe()
    
    func fetchImage(with imageName: String,
                    completion: @escaping (Data) -> Void)
}


protocol RLRecipeButtonDelegate: RLFavoriteChangable, AnyObject {
    func didTapAddIngredientsButton(id: Int)
}

protocol RLFavoriteChangable: AnyObject {
    func didTapFavoriteButton(id: Int)
}

protocol RLLayoutChangable: AnyObject {
    func didTapChangeLayoutButton()
}

/// Протокол делегата бизнес логики модуля RecipeList
protocol BusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля RecipeList
final class RecipeListPresenter {
    
    private(set) var viewModels: [RecipeCellModel] = [] {
        didSet {
            delegate?.updateUI()
        }
    }
    
    weak var delegate: RecipeListViewable?
    private let interactor: RecipeListBusinessLogic
    private let router: RecipeListRouting
    
    init(interactor: RecipeListBusinessLogic,
         router: RecipeListRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    func getStartData() {
        interactor.fetchRandomRecipe(number: 8, tags: ["main course"]) { [weak self] result in
            switch result {
            case .success(let recipeCellModels):
                self?.viewModels = recipeCellModels
            case .failure(_):
                break
            }
        }
    }
}

// MARK: - Presentation
extension RecipeListPresenter: RecipeListPresentation {
    
    func fetchImage(with imageName: String,
               completion: @escaping (Data) -> Void) {
        interactor.fetchImage(imageName) { [weak self] result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                self?.delegate?.showError()
            }
        }
    }
    
    func testTranslate() {
        interactor.translate(texts: ["Hello", "World"])
    }
    
    func testGetRandom() {
        interactor.fetchRandomRecipe(number: 8, tags: ["main course"]) { [weak self] result in
            
            switch result {
            case .success(let recipeCellModels):
                self?.delegate?.updateUI()
            case .failure(_):
                break
            }
        }
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



extension RecipeListPresenter {
    func didTapFavoriteButton(id: Int) {
        print("didTapFavoriteButton")
    }
    
    func didTapAddIngredientsButton(id: Int) {
        print("didTapAddIngredientsButton")
    }
    
    func didTapChangeLayoutButton() {
        print("didTapChangeLayoutButton")
    }
}
