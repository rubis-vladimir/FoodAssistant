//
//  StubBasketInteractor.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubBasketInteractor: BasketBusinessLogic {
    func fetchRecipeFromBasket(completion: @escaping ([FoodAssistant.RecipeViewModel]) -> Void) {
        
    }
    
    func fetchIngredients(completion: @escaping ([FoodAssistant.IngredientViewModel]) -> Void) {
        
    }
    
    func changeIsCheck(id: Int, flag: Bool) {
        
    }
    
    func addIngredientsInFridge() {
        
    }
    
    func getRecipe(id: Int, completion: @escaping (FoodAssistant.RecipeProtocol) -> Void) {
        
    }
    
    func removeRecipe(id: Int) {
        
    }
    
    func fetchImage(_ imageName: String, type: FoodAssistant.TypeOfImage, completion: @escaping (Result<Data, FoodAssistant.DataFetcherError>) -> Void) {
        
    }
}
