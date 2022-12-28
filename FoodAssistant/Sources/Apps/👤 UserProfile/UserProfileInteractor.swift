//
//  UserProfileInteractor.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Слой бизнес логики модуля UserProfile
final class UserProfileInteractor {

    private var models: [RecipeProtocol] = []
    private var ingredients: [IngredientViewModel] = []

    private let imageDownloader: ImageDownloadProtocol
    private let dataFetcher: DataFetcherProtocol
    private let storage: DBRecipeManagement & DBIngredientsManagement
    
    init(imageDownloader: ImageDownloadProtocol,
         dataFetcher: DataFetcherProtocol,
         storage: DBRecipeManagement & DBIngredientsManagement) {
        self.imageDownloader = imageDownloader
        self.dataFetcher = dataFetcher
        self.storage = storage
    }
}

// MARK: - UserProfileBusinessLogic
extension UserProfileInteractor: UserProfileBusinessLogic {
    func find(ingredient: IngredientViewModel, completion: @escaping (Result<IngredientViewModel, DataFetcherError>) -> Void) {
        RecipeRequest
            .findIngredient(ingredient.name)
            .findIngredient(with: dataFetcher) { [weak self] result in
                switch result {
                    
                case .success(let responce):
                    
                    print(responce)
                    guard let dtoIngredient = responce.results.first else {
                        /// Ошибка
                        return }
                    
                    var newModel = ingredient
                    newModel.id = dtoIngredient.id
                    newModel.image = dtoIngredient.image
                    
                    self?.ingredients.append(newModel)
                    self?.storage.save(ingredients: [newModel])
                    completion(.success(newModel))
                    
                case .failure(_):
                    break                    
                }
            }
    }
    
    
    // RecipeReceived
    func getRecipe(id: Int, completion: @escaping (RecipeProtocol) -> Void) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        completion(model)
    }
    
    //ImageBusinessLogic
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
    
    // UserProfileRecipeBL
    func fetchFavoriteRecipe(text: String,
                             completion: @escaping ([RecipeViewModel]) -> Void) {
        storage.fetchRecipes(for: .isFavorite) { [weak self] recipes in
            
            let newRecipes = text == "" ?
                recipes :
                recipes.filter { recipe in
                    let title = recipe.title.lowercased()
                    let text = text.lowercased()
                    return title.contains(text)
                }
            
            self?.models = newRecipes
            
            let viewModels = newRecipes.map {
                RecipeViewModel(with: $0)
            }
            completion(viewModels)
        }
    }
    
    func removeRecipe(id: Int) {
        storage.remove(id: id, for: .isFavorite)
        
        guard let index = models.firstIndex(where: {$0.id == id} ) else { return }
        models.remove(at: index)
    }
    
    func addToBasket(id: Int) {
        guard let model = models.first(where: { $0.id == id }) else { return }
        storage.save(recipe: model, for: .inBasket)
    }
    
    // UserProfileIngredientBL
    func fetchIngredients(completion: @escaping ([IngredientViewModel]) -> Void) {
        storage.fetchIngredients(toUse: false) { [weak self] ingredients in
            let viewModels = ingredients.map { IngredientViewModel(ingredient: $0)}
            self?.ingredients = viewModels
            completion(viewModels)
        }
    }
    
    func changeToUse(id: Int, flag: Bool) {
        guard let index = ingredients.firstIndex(where: {$0.id == id} ) else { return }
        ingredients[index].isCheck = flag
        storage.updateIngredient(id: id, toUse: flag)
    }
    
    func save(ingredient: IngredientProtocol) {
        storage.save(ingredients: [ingredient])
    }
    
    func deleteIngredient(id: Int) {
        storage.removeIngredient(id: id)
    }
}
