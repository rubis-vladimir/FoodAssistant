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
    var arrayIds: [Int]
    
    init(arrayRecipes: [RecipeProtocol] = [],
         arrayIngredients: [IngredientProtocol] = [],
         arrayId: [Int] = []) {
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
        arrayIds.append(recipe.id)
    }
    
    func remove(id: Int,
                for target: TargetOfSave) {
        guard let index = arrayIds.firstIndex(where: { $0 == id }) else { return }
        arrayIds.remove(at: index)
    }
    
    func check(id: Int) -> Bool {
        arrayIds.contains(where: {$0 == id})
    }
    
    func fetchFavoriteId(completion: @escaping ([Int]) -> Void) {
        completion(arrayIds)
    }
    
    func fetchIngredients(toUse: Bool,
                          completion: @escaping ([IngredientProtocol]) -> Void) {
        completion(arrayIngredients)
    }
    
    func save(ingredients: [IngredientProtocol]) {
        let ids = ingredients.map { $0.id }
        arrayIds.append(contentsOf: ids)
    }
    
    func removeIngredient(id: Int) {
        guard let index = arrayIds.firstIndex(where: { $0 == id }) else { return }
        arrayIds.remove(at: index)
    }
    
    func updateIngredient(id: Int, toUse: Bool) {
        self.toUse = toUse
        arrayIds.append(id)
    }
}
