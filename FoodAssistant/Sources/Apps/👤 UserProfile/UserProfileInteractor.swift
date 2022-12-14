//
//  UserProfileInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Слой бизнес логики модуля UserProfile
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

    func getRecipe(id: Int, completion: @escaping (RecipeProtocol) -> Void) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        completion(model)
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
    
    func fetchRecipeFromDB(completion: @escaping ([RecipeViewModel]) -> Void) {
        storage.fetchRecipes(for: .favorite) { [weak self] recipes in
            self?.models = recipes
            
            let viewModels = recipes.map {
                RecipeViewModel(with: $0)
            }
            completion(viewModels)
        }
    }
    
    func removeRecipe(id: Int) {
        storage.remove(id: id, for: .favorite)
        
        guard let index = models.firstIndex(where: {$0.id == id} ) else { return }
        models.remove(at: index)
    }
    
    func addToBasket(id: Int) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        storage.save(recipe: model, for: .basket)
    }
}
