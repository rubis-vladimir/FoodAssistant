//
//  SpyStorageManager.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyStorageManager: DBRecipeManagement & DBIngredientsManagement {
    
    var toUse: Bool?
    var arrayRecipes: [RecipeProtocol]
    var arrayIngredients: [IngredientProtocol]
    var arrayIds: [(Int, Bool)]
    
    init(arrayRecipes: [RecipeProtocol] = [],
         arrayIngredients: [IngredientProtocol] = [],
         arrayId: [(Int, Bool)] = []) {
        self.arrayRecipes = arrayRecipes
        self.arrayIngredients = arrayIngredients
        self.arrayIds = arrayId
    }
    
    
    func fetchRecipes(for target: TargetOfSave,
                      completion: @escaping ([RecipeProtocol]) -> Void) {
        completion(arrayRecipes)
    }
    
    func save(recipe: RecipeProtocol,
              for target: TargetOfSave) {
        arrayIds.append((recipe.id, true))
    }
    
    func remove(id: Int,
                for target: TargetOfSave) {
        arrayIds.append((id, false))
    }
    
    func check(id: Int) -> Bool {
        arrayIds.contains(where: {$0.0 == id})
    }
    
    func fetchFavoriteId(completion: @escaping ([Int]) -> Void) {
        let ids = arrayIds.map{ $0.0 }
        completion(ids)
    }
    
    func fetchIngredients(toUse: Bool,
                          completion: @escaping ([IngredientProtocol]) -> Void) {
        completion(arrayIngredients)
    }
    
    func save(ingredients: [IngredientProtocol]) {
        let ids = ingredients.map { ($0.id, true) }
        arrayIds.append(contentsOf: ids)
    }
    
    func removeIngredient(id: Int) {
        arrayIds.append((id, false))
    }
    
    func updateIngredient(id: Int, toUse: Bool) {
        self.toUse = toUse
        arrayIds.append((id, true))
    }
}
