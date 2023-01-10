//
//  FilterManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 27.12.2022.
//

import UIKit

/// #Протокол управления параметрами фильтрации рецептов
protocol FilterManagement {
    /// Получить параметры фильтра рецепта
    /// - Returns: параметры
    func getRecipeParameters() -> [FilterParameters: [String]]
    
    /// Переписывает параметр
    /// - Parameters:
    ///  - parameter: параметр
    ///  - value: значения для параметра
    func overWrite(parameter: FilterParameters,
                   value: [String])
}

/// #Менеджер работы с фильтром
final class FilterManager {
    
    /// Параметры по умолчанию
    private struct RecipeFilterTagTitles {
        static let time = ["Under 5 min", "Under 15 min", "Under 30 min"]
        static let dishType = ["Main course", "Soup", "Dessert", "Salad", "Side Dish", "Snack", "Drink"]
        static let regions = ["African", "American", "French", "European", "British",
                               "German", "Chinese", "Greek", "Spanish", "Italian", "Vietnamese"]
        static let diets = ["Ketogenic", "Vegetarian", "Vegan", "Pescetarian", "Paleo"]
        static let calories = ["Under 200 Cal", "200 - 400 Cal", "400 - 600 Cal", "600 - 800 Cal"]
        static let includeIngredients = ["Chicken", "Beef", "Pasta", "Tomato", "Cheese"]
        static let excludeIngredients = ["Onion", "Broccoli", "Egg", "Olives"]
    }
}

// MARK: - FilterManagement
extension FilterManager: FilterManagement {
    
    func getRecipeParameters() -> [FilterParameters: [String]] {
        var dict = [FilterParameters: [String]]()
        dict[.time] = RecipeFilterTagTitles.time
        dict[.dishType] = RecipeFilterTagTitles.dishType
        dict[.region] = RecipeFilterTagTitles.regions
        dict[.diet] = RecipeFilterTagTitles.diets
        dict[.calories] = RecipeFilterTagTitles.calories
        
        let key1 = FilterParameters.includeIngredients.title
        if let titles = UserDefaults.standard.value(forKey: key1) as? [String] {
            dict[.includeIngredients] = titles
        } else {
            dict[.includeIngredients] = RecipeFilterTagTitles.includeIngredients
            UserDefaults.standard.set(RecipeFilterTagTitles.includeIngredients, forKey: key1)
        }
        
        
        let key2 = FilterParameters.excludeIngredients.title
        if let titles = UserDefaults.standard.value(forKey: key2) as? [String] {
            dict[.excludeIngredients] = titles
        } else {
            dict[.includeIngredients] = RecipeFilterTagTitles.excludeIngredients
            UserDefaults.standard.set(RecipeFilterTagTitles.excludeIngredients, forKey: key2)
        }
        return dict
    }
    
    func overWrite(parameter: FilterParameters, value: [String]) {
        UserDefaults.standard.set(value, forKey: parameter.title)
    }
}
