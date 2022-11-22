//
//  Presenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол передачи UI-ивентов слою презентации модуля RecipeList
protocol RecipeListPresentation: AnyObject {
    var recipeCellModels: [RecipeCellModel] { get }
    func testTranslate()
    
    func testGetRandom()
    func testGetRecipe()
    
    func fetchImage(with imageName: String,
                    completion: @escaping (Data) -> Void)
}

protocol FavoriteButtonDelegate {
    func didTapFavoriteButton()
}

/// Протокол делегата бизнес логики модуля RecipeList
protocol BusinessLogicDelegate: AnyObject {
    
}

/// Слой презентации модуля RecipeList
final class RecipeListPresenter {
    
    private(set) var recipeCellModels: [RecipeCellModel] = [] {
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
        interactor.fetchRandomRecipe(number: 8, tags: ["salad"]) { [weak self] result in
            switch result {
            case .success(let recipeCellModels):
                self?.recipeCellModels = recipeCellModels
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
        interactor.fetchRandomRecipe(number: 8, tags: ["salad"]) { [weak self] result in
            
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

extension RecipeListPresenter: FavoriteButtonDelegate {
    func didTapFavoriteButton() {
        print("XSXXSX")
    }
    
    
}
