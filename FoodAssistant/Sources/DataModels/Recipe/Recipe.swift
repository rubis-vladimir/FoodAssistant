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
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let sustainable: Bool
    let weightWatcherSmartPoints: Int
    let gaps: String
    let lowFodmap: Bool
    let aggregateLikes: Int
    let spoonacularScore: Int?
    let healthScore: Int
    let creditsText: String?
    let license: String?
    let sourceName: String?
    let pricePerServing: Float
    let extendedIngredients: [Ingredient]?
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let image: String?
    let imageType: String?
    let nutrition: Nutrition?
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let occasions: [String]
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
    let aisle: String?
    let image: String?
    let consistency: String?
    let name: String
    let nameClean: String?
    let original: String?
    let originalName: String?
    let amount: Float?
    let unit: String?
    let meta: [String]?
    let measures: Measure?
}

struct Measure: Codable, Hashable {
    let us: MeasureInfo
    let metric: MeasureInfo
}

struct MeasureInfo: Codable, Hashable {
    let amount: Float
    let unitShort: String
    let unitLong: String
}

struct Instruction: Codable, Hashable {
    let name: String
    let steps: [InstuctionStep]
}

struct InstuctionStep: Codable, Hashable {
    let number: Int
    let step: String
    let ingredients: [Ingredient]
    let equipment: [Equipment]
    let length: Length?
}

struct Equipment: Codable, Hashable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String
}

struct Length: Codable, Hashable {
    let number: Int
    let unit: String
}

struct Nutrition: Codable, Hashable {
    let nutrients: [Nutrient]
    let properties: [Nutrient]
    let flavonoids: [Nutrient]
    let ingredients: [Ingredient]
    let caloricBreakdown: CaloricBreakdown
    let weightPerServing: Weight
    
    var calories: String {
        let caloriesNutrient = nutrients[0]
        let finalString = "\(Int(caloriesNutrient.amount)) kcal"
        return finalString
    }
    
    var fats: String {
        let fatsNutrient = nutrients[1]
        let finalString = "\(Int(fatsNutrient.amount))g fats"
        return finalString
    }
    
    var carbohydrates: String {
        let carbohydratesNutrient = nutrients[3]
        let finalString = "\(Int(carbohydratesNutrient.amount))g carbs"
        return finalString
    }
    
    var protein: String {
        let proteinNutrient = nutrients[8]
        let finalString = "\(Int(proteinNutrient.amount))g protein"
        return finalString
    }
}

struct Nutrient: Codable, Hashable {
    let name: String
    let amount: Float
    let unit: String
    let percentOfDailyNeeds: Float?
}

struct NutritionIngredient: Codable, Hashable {
    let id: Int
    let name: String
    let amount: Float
    let unit: String
    let nutrients: [Nutrient]
}

struct CaloricBreakdown: Codable, Hashable {
    let percentProtein: Float
    let percentFat: Float
    let percentCarbs: Float
}

struct Weight: Codable, Hashable {
    let amount: Int
    let unit: String
}

