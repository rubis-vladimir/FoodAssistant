//
//  StubStorageManager.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubStorageManager: DBRecipeManagement & DBIngredientsManagement {
    func fetchRecipes(for target: FoodAssistant.TargetOfSave, completion: @escaping ([FoodAssistant.RecipeProtocol]) -> Void) {
        <#code#>
    }
    
    func save(recipe: FoodAssistant.RecipeProtocol, for target: FoodAssistant.TargetOfSave) {
        <#code#>
    }
    
    func remove(id: Int, for target: FoodAssistant.TargetOfSave) {
        <#code#>
    }
    
    func check(id: Int) -> Bool {
        <#code#>
    }
    
    func fetchFavoriteId(completion: @escaping ([Int]) -> Void) {
        <#code#>
    }
    
    func fetchIngredients(toUse: Bool, completion: @escaping ([FoodAssistant.IngredientProtocol]) -> Void) {
        <#code#>
    }
    
    func save(ingredients: [FoodAssistant.IngredientProtocol]) {
        <#code#>
    }
    
    func removeIngredient(id: Int) {
        <#code#>
    }
    
    func updateIngredient(id: Int, toUse: Bool) {
        <#code#>
    }
}
