//
//  DetailInfoInteractor.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Слой бизнес логики модуля DetailInfo
final class DetailInfoInteractor {
    
    private var ingredientsFromFridge: [IngredientViewModel] = []
    
    private let imageDownloader: ImageDownloadProtocol
    private let storage: DBIngredientsManagement
    
    init(imageDownloader: ImageDownloadProtocol,
         storage: DBIngredientsManagement) {
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
    func checkFor(ingredient: IngredientViewModel) -> Bool {
        guard let ingredientInFridge = ingredientsFromFridge.first(where: {$0 == ingredient}),
//              ingredientInFridge.unit == ingredient.unit,
              ingredientInFridge.amount >= ingredient.amount else { return false }
        return true
    }
    
    
    func fetchImageRecipe(_ imageName: String, 
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader,
                      completion: completion)
    }
    
    func fetchImageIngredients(_ imageName: String, size: ImageSize,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
       
        ImageRequest
            .ingredient(imageName: imageName,
                        size: size)
            .download(with: imageDownloader,
                      completion: completion)
    }
}
