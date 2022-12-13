//
//  UserProfileInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Слой бизнес логике модуля UserProfile
final class UserProfileInteractor {
    private var models: [RecipeProtocol] = []

    private let imageDownloader: ImageDownloadProtocol
    private let storage: DBRecipeManagement
    
    init(imageDownloader: ImageDownloadProtocol,
         storage: DBRecipeManagement) {
        self.imageDownloader = imageDownloader
        self.storage = storage
    }
}

// MARK: - UserProfileBusinessLogic
extension UserProfileInteractor: UserProfileBusinessLogic {
    func getModel(id: Int, completion: @escaping (RecipeProtocol) -> Void) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        completion(model)
    }
    
    func fetchRecipeImage(_ imageName: String, completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader, completion: completion)
    }
    
    func fetchIngredientImage(_ imageName: String, size: ImageSize,
                              completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .ingredient(imageName: imageName, size: size)
            .download(with: imageDownloader, completion: completion)
    }
    
    func fetchRecipeFromDB(completion: @escaping ([RecipeViewModel]) -> Void) {
        storage.fetchRecipes(for: .favorite) { [weak self] recipes in
            self?.models = recipes
            
            let viewModels = recipes.map {
                RecipeViewModel(with: $0)
            }
            completion(viewModels)
        }
    }
}
