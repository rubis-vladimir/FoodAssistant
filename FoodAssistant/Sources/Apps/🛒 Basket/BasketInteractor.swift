//
//  Interactor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол управления бизнес логикой модуля Basket
protocol BasketBusinessLogic {
    func fetchRecipeFromDB(completion: @escaping ([RecipeProtocol]) -> Void)
    
    func fetchRecipeImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// Слой бизнес логике модуля Basket
final class BasketInteractor {
    private var models: [RecipeProtocol] = []

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
    func fetchRecipeImage(_ imageName: String, completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader,
                      completion: completion)
    }
    
    func fetchRecipeFromDB(completion: @escaping ([RecipeProtocol]) -> Void) {
        storage.fetchRecipes { [weak self] recipes in
            self?.models = recipes
//            let viewModels = recipes.map {
//                RecipeViewModel(with: $0)
//            }
            completion(recipes)
        }
    }
}
