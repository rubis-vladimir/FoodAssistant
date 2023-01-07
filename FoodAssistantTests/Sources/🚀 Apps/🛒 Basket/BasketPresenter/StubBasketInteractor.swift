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
        <#code#>
    }
    
    func fetchIngredients(completion: @escaping ([FoodAssistant.IngredientViewModel]) -> Void) {
        <#code#>
    }
    
    func changeIsCheck(id: Int, flag: Bool) {
        <#code#>
    }
    
    func addIngredientsInFridge() {
        <#code#>
    }
    
    func getRecipe(id: Int, completion: @escaping (FoodAssistant.RecipeProtocol) -> Void) {
        <#code#>
    }
    
    func removeRecipe(id: Int) {
        <#code#>
    }
    
    func fetchImage(_ imageName: String, type: FoodAssistant.TypeOfImage, completion: @escaping (Result<Data, FoodAssistant.DataFetcherError>) -> Void) {
        <#code#>
    }
}
