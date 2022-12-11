//
//  UserProfileInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// Протокол управления бизнес логикой модуля UserProfile
protocol UserProfileBusinessLogic {
    
    func getModel(id: Int,
                  completion: @escaping (RecipeProtocol) -> Void)
    
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchRecipeImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    func fetchIngredientImage(_ imageName: String, size: ImageSize,
                              completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    func fetchRecipeFromDB(completion: @escaping ([RecipeViewModel]) -> Void)
    
}

/// Слой бизнес логике модуля UserProfile
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

// MARK: - BusinessLogic
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
        storage.fetchRecipes { [weak self] recipes in
            self?.models = recipes
            
            let viewModels = recipes.map {
                RecipeViewModel(with: $0)
            }
            completion(viewModels)
        }
    }
}
