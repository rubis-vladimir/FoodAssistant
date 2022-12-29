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

// MARK: - Recipe
/// #Модель рецепта
struct Recipe: RecipeProtocol, Codable, Equatable, Hashable {
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
    
    /// Собственное свойство модели
    /// Флаг избранного рецепта
    var isFavorite: Bool = false
    
    enum CodingKeys: CodingKey {
        case id, title, readyInMinutes, servings, extendedIngredients, image, nutrition, analyzedInstructions
    }
}

extension Recipe {
    
    var imageName: String? {
        guard let image = image else { return nil }
        return String(image.dropFirst(37))
    }
    
    var ingredients: [IngredientProtocol]? {
        combine(ingredients: extendedIngredients)
    }
    
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
    
    /// Объединяет ингредиенты если они повторяются в рецепте
    func combine(ingredients: [Ingredient]?) -> [Ingredient]? {
         
        guard let ingredients = ingredients else { return nil }
        
        var finalArray: [Ingredient] = []
        let arrayId = ingredients.map { $0.id }
        let dublicateId = arrayId.duplicate()
        
        ingredients.forEach {
            if !dublicateId.contains($0.id) {
                finalArray.append($0)
            }
        }
        
        dublicateId.forEach { id in
            let dublicate = ingredients.filter{ $0.id == id }
            let amount = dublicate.map { $0.amount }.reduce(0, +)
            let ingredient = Ingredient(id: dublicate[0].id,
                                        image: dublicate[0].image,
                                        name: dublicate[0].name,
                                        dtoAmount: amount,
                                        dtoUnit: dublicate[0].unit)
            finalArray.append(ingredient)
        }
    
        return finalArray
    }
}

// MARK: - Ingredient
/// #Модель ингредиента
struct Ingredient: IngredientProtocol, Codable, Hashable, Equatable {

    /// Идентификатор ингредиента
    var id: Int
    /// Название изображения ингредиента
    var image: String?
    /// Название ингредиента
    var name: String
    /// Количество
    var dtoAmount: Float
    /// Единицы измерения
    var dtoUnit: String?
    /// Флаг использования
    var toUse: Bool { false }
    
    enum CodingKeys: String, CodingKey {
        case id, image, name
        case dtoAmount = "amount"
        case dtoUnit = "unit"
    }
}

extension Ingredient {
    var unit: String {
        getUnit()
    }
    
    var amount: Float {
        getAmount()
    }
    
    /// Получает обновленное количество
    func getAmount() -> Float {
        if ["ounce", "ounces", "oz"].contains(dtoUnit) {
            /// Переводим в граммы из тройской унции
            return 31.1 * dtoAmount
        } else if ["lb", "lbs", "pounds", "pound"].contains(dtoUnit) {
            /// Переводим в граммы из фунта
            return 453.6 * dtoAmount
        } else {
            return dtoAmount
        }
    }
    
    /// Приводит единицы измерения к одному варианту отображения
    func getUnit() -> String {
        let unit = dtoUnit?.lowercased()
        
        if ["tbsps", "tbs", "tbsp", "tablespoons", "tablespoon"].contains(unit) {
            return "tbsp" // Столовая ложка
        } else if ["tsps", "teaspoons", "teaspoon", "tsp", "t"].contains(unit) {
            return "tsp" // Чайная ложка
        } else if ["cups", "cup", "c"].contains(unit) {
            return "cup" // Чашка
        } else if ["ounce", "ounces", "oz", "g", "lb", "lbs", "pounds", "pound", "grams"].contains(unit) {
            return "g" // Грамм
        } else if ["serving", "servings"].contains(unit) {
            return "serv" // Порция
        } else if ["small", "large", "medium"].contains(unit) {
            return ""
        } else {
            guard let unit = dtoUnit else { return "" }
            return unit
        }
    }
}

// MARK: - Instruction
/// #Модель инструкции по приготовлению
struct Instruction: Codable, Hashable {
    /// Название
    var name: String
    /// Шаги
    var steps: [InstuctionStep]
}

/// #Модель этапа(шага) приготовления
struct InstuctionStep: InstructionStepProtocol, Codable, Hashable {
    /// Номер
    var number: Int
    /// Текстовая информация
    var step: String
}

// MARK: - Nutrition
/// #Модель питательных веществ
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

/// #Модель питательного вещества
struct Nutrient: NutrientProtocol, Codable, Hashable {
    /// Название
    var name: String
    /// Количество
    var amount: Float
    /// Единицы измерения
    var unit: String
}
