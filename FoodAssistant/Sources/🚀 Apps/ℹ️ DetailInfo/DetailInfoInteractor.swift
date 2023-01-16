//
//  DetailInfoInteractor.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Слой бизнес логики модуля DetailInfo
final class DetailInfoInteractor {
    /// Вью модели ингредиентов из холодильника
    private var ingredientsFromFridge: [IngredientViewModel] = []
    
    private let imageDownloader: ImageDownloadProtocol
    private let storage: DBIngredientsManagement & DBRecipeManagement
    
    init(imageDownloader: ImageDownloadProtocol,
         storage: DBIngredientsManagement & DBRecipeManagement) {
        self.imageDownloader = imageDownloader
        self.storage = storage
        
        fetchFromFridge()
    }
    
    private func fetchFromFridge() {
        storage.fetchIngredients(toUse: false) { [weak self] ingredients in
            let models = ingredients.map { IngredientViewModel(ingredient: $0) }
            self?.ingredientsFromFridge = models
        }
    }
}

// MARK: - DetailInfoBusinessLogic
extension DetailInfoInteractor: DetailInfoBusinessLogic {
    
    func fetchImage(_ imageName: String, type: TypeOfImage, completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        switch type {
        case .recipe:
            ImageRequest
                .recipe(imageName: imageName)
                .download(with: imageDownloader,
                          completion: completion)
        case .ingredient:
            ImageRequest
                .ingredient(imageName: imageName,
                            size: .mini)
                .download(with: imageDownloader,
                          completion: completion)
        }
    }
    
    func updateFavotite(_ flag: Bool, recipe: RecipeProtocol) {
        if flag {
            storage.save(recipe: recipe, for: .isFavorite)
        } else {
            storage.remove(id: recipe.id, for: .isFavorite)
        }
    }
    
    func checkFor(ingredient: IngredientViewModel) -> Bool {
        guard let ingredientInFridge = ingredientsFromFridge.first(where: {$0 == ingredient}),
              ingredientInFridge.amount >= ingredient.amount else { return false }
        return true
    }
}
