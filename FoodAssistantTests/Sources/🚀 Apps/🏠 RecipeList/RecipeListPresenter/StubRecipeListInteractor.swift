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
        
    }
    
    func fetchRecommended(number: Int, completion: @escaping (Result<[FoodAssistant.RecipeViewModel], FoodAssistant.DataFetcherError>) -> Void) {
        
    }
    
    func saveRecipe(id: Int, for target: FoodAssistant.TargetOfSave) {
        
    }
    
    func updateFavoriteId() {
        
    }
    
    func checkFavorite(id: Int) -> Bool {
        true
    }
    
    func getRecipe(id: Int, completion: @escaping (FoodAssistant.RecipeProtocol) -> Void) {
        
    }
    
    func fetchImage(_ imageName: String, type: FoodAssistant.TypeOfImage, completion: @escaping (Result<Data, FoodAssistant.DataFetcherError>) -> Void) {
        
    }
    
    func removeRecipe(id: Int) {
        
    }
}
