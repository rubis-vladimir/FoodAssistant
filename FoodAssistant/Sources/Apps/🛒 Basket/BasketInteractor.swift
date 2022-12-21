//
//  BasketInteractor.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол взаимодействия со слоем презентации модуля Basket
protocol BasketBusinessLogicDelegate: AnyObject {
    
    /// Передает ингредиенты
    ///  - Parameter ingredients: массив ингредиентов
    func handOver(ingredients: [IngredientProtocol])
}

/// #Слой бизнес логики модуля Basket
final class BasketInteractor {
    
    weak var presenter: BasketBusinessLogicDelegate?
    
    private var models: [RecipeProtocol] = []
    private var ingredients: [IngredientProtocol] = []

    private let imageDownloader: ImageDownloadProtocol
    private let storage: DBRecipeManagement
    private let ingredientManager: ShopListCalculatable
    
    init(imageDownloader: ImageDownloadProtocol,
         storage: DBRecipeManagement,
         ingredientManager: ShopListCalculatable) {
        self.imageDownloader = imageDownloader
        self.storage = storage
        self.ingredientManager = ingredientManager
    }
}


// MARK: - BasketBusinessLogic
extension BasketInteractor: BasketBusinessLogic {
    
    func getRecipe(id: Int,
                   completion: @escaping (RecipeProtocol) -> Void) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        completion(model)
    }
    
    func fetchRecipeInBasket(completion: @escaping ([RecipeProtocol]) -> Void) {
        storage.fetchRecipes(for: .inBasket) { [weak self] recipes in
            self?.models = recipes
            completion(recipes)
        }
    }
    
    func fetchIngredients(completion: @escaping ([IngredientViewModel]) -> Void) {
        guard !models.isEmpty else { return }
        getIngredients(complection: completion)
    }
    
    func deleteFromBasket(id: Int) {
        storage.remove(id: id, for: .inBasket)
        
        guard let index = models.firstIndex(where: {$0.id == id} ) else { return }
        models.remove(at: index)
    }
    
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        switch type {
        case .recipe:
            ImageRequest
                .recipe(imageName: imageName)
                .download(with: imageDownloader,
                          completion: completion)
        case .ingredient:
            ImageRequest
                .ingredient(imageName: imageName, size: .mini)
                .download(with: imageDownloader,
                          completion: completion)
        }
    }
}

extension BasketInteractor {
    private func getIngredients(complection: @escaping ([IngredientViewModel]) -> Void) {
        let ingredients = models.map {
            $0.ingredients ?? []
        }.reduce([], +)
        
        ingredientManager.getShopList(ingredients: ingredients,
                                      complection: complection)
    }
}
