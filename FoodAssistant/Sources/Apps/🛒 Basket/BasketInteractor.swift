//
//  BasketInteractor.swift
//  ModuleVIPER
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
    
    private var models: [RecipeProtocol] = [] {
        didSet {
            
            
        }
    }

    private let imageDownloader: ImageDownloadProtocol
    private let storage: DBRecipeManagement
    
    init(imageDownloader: ImageDownloadProtocol,
         storage: DBRecipeManagement) {
        self.imageDownloader = imageDownloader
        self.storage = storage
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
        storage.fetchRecipes(for: .basket) { [weak self] recipes in
            self?.models = recipes
            completion(recipes)
        }
    }
    
    func fetchIngredients(completion: @escaping ([IngredientProtocol]) -> Void) {
        guard !models.isEmpty else { return }
        let arrayIngredients = getIngredients()
        completion(arrayIngredients)
    }
    
    func deleteFromBasket(id: Int) {
        storage.remove(id: id, for: .basket)
        
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
    private func getIngredients() -> [IngredientProtocol] {
        let ingredients = models.map {
            $0.ingredients ?? []
        }.reduce([], +)
        
        return ingredients.sorted(by: {$0.name > $1.name})
    }
}
