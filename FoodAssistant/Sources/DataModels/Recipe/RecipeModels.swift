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
    var id: Int
    /// Название рецепта
    var title: String
    /// Полная готовность в мин
    var readyInMinutes: Int
    /// Количество порций
    var servings: Int
    /// Массив используемых ингредиентов
    var extendedIngredients: [Ingredient]?
    /// Изображение рецепта
    var image: String?
    /// Информация по питательным веществам
    var nutrition: Nutrition?
    /// Инструкции для приготовления
    var analyzedInstructions: [Instruction]?
    
    /// Теги
    var vegetarian: Bool
    var vegan: Bool
    var glutenFree: Bool
    var dairyFree: Bool
    
    /// Пока не требуются
//    var cuisines: [String]
//    var dishTypes: [String]
//    var diets: [String]
//    var spoonacularSourceUrl: String?
//    var isFavorite: Bool?
    
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
    var id: Int?
    /// Название изображения ингредиента
    var image: String?
    /// Название ингредиента
    var name: String
    /// Количество
    var amount: Float?
    /// Единицы измерения
    var unit: String?
    
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
    var name: String
    /// Шаги
    var steps: [InstuctionStep]
}

// Модель этапа(шага) приготовления
struct InstuctionStep: Codable, Hashable {
    /// Номер
    var number: Int
    /// Текстовая информация
    var step: String
}

// Модель питательных веществ
struct Nutrition: Codable, Hashable {
    /// Массив питателных веществ
    var nutrients: [Nutrient]

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
    var name: String
    /// Количество
    var amount: Float
    /// Единицы измерения
    var unit: String
}
