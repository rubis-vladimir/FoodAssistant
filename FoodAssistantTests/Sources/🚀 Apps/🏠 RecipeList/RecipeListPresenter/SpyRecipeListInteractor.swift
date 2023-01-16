//
//  SpyRecipeListInteractor.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyRecipeListInteractor: RecipeListBusinessLogic {

    var recipeModels: [RecipeProtocol]
    var viewModels: [RecipeViewModel]
    var arrayIds: [Int]
    var error: DataFetcherError?

    init(recipeModels: [RecipeProtocol] = [],
         arrayId: [Int] = [],
         error: DataFetcherError? = nil) {
        self.recipeModels = recipeModels
        viewModels = recipeModels.map { RecipeViewModel(with: $0) }
        self.arrayIds = arrayId
        self.error = error
    }

    func fetchRecipe(with parameters: RecipeFilterParameters,
                     number: Int,
                     query: String?,
                     completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(viewModels))
        }
    }

    func fetchRecommended(number: Int,
                          completion: @escaping (Result<[RecipeViewModel], DataFetcherError>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(viewModels))
        }
    }

    func checkFavorite(id: Int) -> Bool {
        arrayIds.contains(id)
    }

    func getRecipe(id: Int,
                   completion: @escaping (RecipeProtocol) -> Void) {
        guard let recipe = recipeModels.first(where: {$0.id == id}) else { return }
        completion(recipe)
    }

    func updateFavoriteId() {
        // не проверяю
    }

    func saveRecipe(id: Int,
                    for target: TargetOfSave) {
        arrayIds.append(id)
    }

    func removeRecipe(id: Int) {
        guard let index = arrayIds.firstIndex(where: { $0 == id }) else { return }
        arrayIds.remove(at: index)
    }

    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        // не проверяю
    }
}
