//
//  RecipeModels.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

/// #Модель ответа по запросу рецептов
struct RecipeResponce: Codable, Hashable {
    var recipes: [Recipe]?
    var results: [Recipe]?
}

/// #Модель рецепта
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
    
    var isFavorite: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.readyInMinutes = try container.decode(Int.self, forKey: .readyInMinutes)
        self.servings = try container.decode(Int.self, forKey: .servings)
        self.extendedIngredients = try container.decodeIfPresent([Ingredient].self, forKey: .extendedIngredients)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.nutrition = try container.decodeIfPresent(Nutrition.self, forKey: .nutrition)
        self.analyzedInstructions = try container.decodeIfPresent([Instruction].self, forKey: .analyzedInstructions)
    }
}

// MARK: - RecipeProtocol
extension Recipe: RecipeProtocol {
    
    var imageName: String? {
        guard let image = image else { return nil }
        return String(image.dropFirst(37))
    }
    
    var ingredients: [IngredientProtocol]? { extendedIngredients }
    
    var nutrients: [NutrientProtocol]? { nutrition?.nutrients }
    
    var instructions: [InstructionStepProtocol]? { analyzedInstructions?.first?.steps }
    
    /// Время приготовления в часах и минутах
    var cookingTime: String {
        let hours = readyInMinutes / 60
        let minutes = readyInMinutes % 60
        
        return hours > 0 && minutes > 0 // Условие 1
        ? "\(hours) ч \(minutes) мин" :
        hours > 0 // Условие 2
        ? "\(hours) ч"
        :  "\(minutes) мин"
    }
}

// Модель ингредиента
struct Ingredient: IngredientProtocol, Codable, Hashable, Equatable {
    
    /// Идентификатор ингредиента
    var id: Int
    /// Название изображения ингредиента
    var image: String?
    /// Название ингредиента
    var name: String
    /// Количество
    var amount: Float
    /// Единицы измерения
    var unit: String?
    /// Флаг использования
    var toUse: Bool { false }
    
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
struct InstuctionStep: InstructionStepProtocol, Codable, Hashable {
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
struct Nutrient: NutrientProtocol, Codable, Hashable {
    /// Название
    var name: String
    /// Количество
    var amount: Float
    /// Единицы измерения
    var unit: String
}
