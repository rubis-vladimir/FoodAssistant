//
//  FilterParameters.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

// Параметры для запроса рецептов
struct RecipeFilterParameters {
    /// Вид кухни
    var cuisine: String?
    /// Диета
    var diet: String?
    /// Тип рецепта
    var type: String?
    /// Включая ингредиенты
    var includeIngredients: [String]
    /// Исключая ингредиенты
    var excludeIngredients: [String]
    /// Непереносимости
    var intolerances: [String]
    /// Максимальное количество каллорий в рецепте
    var maxCalories: Int?
    /// Сортировка
    var sort: String?
    
    init(cuisine: String?, diet: String?, type: String?, intolerances: [String], includeIngredients: [String], excludeIngredients: [String], maxCalories: Int?, sort: String?) {
        self.cuisine = cuisine
        self.diet = diet
        self.type = type
        self.intolerances = intolerances
        self.includeIngredients = includeIngredients
        self.excludeIngredients = excludeIngredients
        self.maxCalories = maxCalories
        self.sort = sort
    }
    
    init() {
        cuisine = nil
        diet = nil
        type = nil
        intolerances = []
        includeIngredients = []
        excludeIngredients = []
        maxCalories = nil
        sort = nil
    }
}
