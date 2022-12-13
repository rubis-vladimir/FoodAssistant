//
//  BasketPresenter.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation



/// #Протокол управления View-слоем
protocol BasketViewable: AnyObject {
    /// Обновление UI
    func updateUI(with models: [RecipeProtocol])
    /// Показать ошибку
    func showError()
}

/// #Слой презентации модуля Basket
final class BasketPresenter {
    
    var models: [RecipeProtocol] = [] {
        didSet {
            delegate?.updateUI(with: models)
        }
    }
    
    weak var delegate: BasketViewable?
    private let interactor: BasketBusinessLogic
    private let router: BasketRouting
    
    init(interactor: BasketBusinessLogic,
         router: BasketRouting) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - BasketPresentation
extension BasketPresenter: BasketPresentation {
    
    func fetchRecipeImage(with imageName: String,
                          completion: @escaping (Data) -> Void) {
        interactor.fetchRecipeImage(imageName) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchAddedRecipe() {
        interactor.fetchRecipeFromDB { [weak self] recipes in
            self?.models = recipes
        }
    }
    
    func didTapFavoriteButton(_ isFavorite: Bool, id: Int) {
        
    }
    
    
}
