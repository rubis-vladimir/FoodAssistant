//
//  Recipe.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

// Модель ответа по запросу рецептов
struct RecipeResponce: Codable, Hashable {
    var recipes: [Recipe]?
    var results: [Recipe]?
}

// Модель рецепта
struct Recipe: Codable, Equatable, Hashable {
    /// Идентификатор
    let id: Int
    /// Название рецепта
    let title: String
    /// Полная готовность в мин
    let readyInMinutes: Int
    /// Количество порций
    let servings: Int
    /// Массив используемых ингредиентов
    let extendedIngredients: [Ingredient]?
    /// Изображение рецепта
    let image: String?
    /// Информация по питательным веществам
    let nutrition: Nutrition?
    /// Инструкции для приготовления
    let analyzedInstructions: [Instruction]?
    
    /// Теги
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    
    /// ?
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let instructions: String?
    let spoonacularSourceUrl: String?
    var isFavorite: Bool?
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}

// Модель ингредиента
struct Ingredient: Codable, Hashable, Equatable {
    /// Идентификатор ингредиента
    let id: Int?
    /// Название изображения ингредиента
    let image: String?
    /// Название ингредиента
    let name: String
    /// Количество
    let amount: Float?
    /// Единицы измерения
    let unit: String?
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}

// Модель инструкции по приготовлению
struct Instruction: Codable, Hashable {
    /// Название
    let name: String
    /// Шаги
    let steps: [InstuctionStep]
}

// Модель этапа(шага) приготовления
struct InstuctionStep: Codable, Hashable {
    /// Номер
    let number: Int
    /// Текстовая информация
    let step: String
}

// Модель питательных веществ
struct Nutrition: Codable, Hashable {
    /// Массив питателных веществ
    let nutrients: [Nutrient]

    /// Информация для о количестве питательных веществ (калории, белки, жиры, углеводы):
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

// Модель питательного вещества
struct Nutrient: Codable, Hashable {
    /// Название
    let name: String
    /// Количество
    let amount: Float
    /// Единицы измерения
    let unit: String
}
