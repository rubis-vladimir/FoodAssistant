//
//  StubRecipeListInteractor.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubRecipeListInteractor: RecipeListBusinessLogic {
    func fetchRecipe(with parameters: FoodAssistant.RecipeFilterParameters, number: Int, query: String?, completion: @escaping (Result<[FoodAssistant.RecipeViewModel], FoodAssistant.DataFetcherError>) -> Void) {
        <#code#>
    }
    
    func fetchRecommended(number: Int, completion: @escaping (Result<[FoodAssistant.RecipeViewModel], FoodAssistant.DataFetcherError>) -> Void) {
        <#code#>
    }
    
    func saveRecipe(id: Int, for target: FoodAssistant.TargetOfSave) {
        <#code#>
    }
    
    func updateFavoriteId() {
        <#code#>
    }
    
    func checkFavorite(id: Int) -> Bool {
        <#code#>
    }
    
    func getRecipe(id: Int, completion: @escaping (FoodAssistant.RecipeProtocol) -> Void) {
        <#code#>
    }
    
    func fetchImage(_ imageName: String, type: FoodAssistant.TypeOfImage, completion: @escaping (Result<Data, FoodAssistant.DataFetcherError>) -> Void) {
        <#code#>
    }
    
    func removeRecipe(id: Int) {
        <#code#>
    }
}
