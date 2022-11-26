//
//  Recipe.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

struct RecipeModel: Codable, Hashable {
    var recipes: [Recipe]?
    var results: [Recipe]?
}

struct Recipe: Codable, Equatable, Hashable {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let extendedIngredients: [Ingredient]?
    let image: String?
    
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    
    
    let nutrition: Nutrition?
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let instructions: String?
    let analyzedInstructions: [Instruction]
    let spoonacularSourceUrl: String?
    var isFavorite: Bool?
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}

struct Ingredient: Codable, Hashable {
    let id: Int?
    let image: String?
    let name: String
    let amount: Float?
    let unit: String?
}

struct Instruction: Codable, Hashable {
    let name: String
    let steps: [InstuctionStep]
}

struct InstuctionStep: Codable, Hashable {
    let number: Int
    let step: String
//    let ingredients: [Ingredient]
}

struct Nutrition: Codable, Hashable {
    let nutrients: [Nutrient]
    
    var calories: String? {
        guard let caloriesNutrient = nutrients.first(where: { $0.name == "Calories" }) else { return nil }
        let finalString = "\(Int(caloriesNutrient.amount))"
        return finalString
    }
    
    var protein: String? {
        guard let proteinNutrient = nutrients.first(where: { $0.name == "Protein" }) else { return nil }
        let finalString = "\(Int(proteinNutrient.amount)) \(proteinNutrient.unit)"
        return finalString
    }
    
    var fats: String? {
        guard let fatsNutrient = nutrients.first(where: { $0.name == "Fat" }) else { return nil }
        let finalString = "\(Int(fatsNutrient.amount)) \(fatsNutrient.unit)"
        return finalString
    }
    
    var carbohydrates: String? {
        guard let carbohydratesNutrient = nutrients.first(where: { $0.name == "Carbohydrates" }) else { return nil }
        let finalString = "\(Int(carbohydratesNutrient.amount)) \(carbohydratesNutrient.unit)"
        return finalString
    }
}

struct Nutrient: Codable, Hashable {
    let name: String
    let amount: Float
    let unit: String
}
