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
        
    }
    
    func save(recipe: FoodAssistant.RecipeProtocol, for target: FoodAssistant.TargetOfSave) {
        
    }
    
    func remove(id: Int, for target: FoodAssistant.TargetOfSave) {
        
    }
    
    func check(id: Int) -> Bool {
        true
    }
    
    func fetchFavoriteId(completion: @escaping ([Int]) -> Void) {
        
    }
    
    func fetchIngredients(toUse: Bool, completion: @escaping ([FoodAssistant.IngredientProtocol]) -> Void) {
        
    }
    
    func save(ingredients: [FoodAssistant.IngredientProtocol]) {
        
    }
    
    func removeIngredient(id: Int) {
        
    }
    
    func updateIngredient(id: Int, toUse: Bool) {
        
    }
}
