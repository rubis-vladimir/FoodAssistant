//
//  FilterParameters.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

/// #Параметры для запроса рецептов
struct RecipeFilterParameters {
    /// Время
    var time: Int?
    /// Вид кухни
    var cuisine: [String]
    /// Диета
    var diet: String?
    /// Тип рецепта
    var type: [String]
    /// Включая ингредиенты
    var includeIngredients: [String]
    /// Исключая ингредиенты
    var excludeIngredients: [String]
    /// Непереносимости
    var intolerances: [String]
    /// Минимальное количество каллорий в рецепте
    var minCalories: Int?
    /// Максимальное количество каллорий в рецепте
    var maxCalories: Int?
    /// Сортировка
    var sort: String?
    
    init(time: Int?,
         cuisine: [String],
         diet: String?,
         type: [String],
         intolerances: [String],
         includeIngredients: [String],
         excludeIngredients: [String],
         minCalories: Int?,
         maxCalories: Int?,
         sort: String?) {
        self.time = time
        self.cuisine = cuisine
        self.diet = diet
        self.type = type
        self.intolerances = intolerances
        self.includeIngredients = includeIngredients
        self.excludeIngredients = excludeIngredients
        self.minCalories = minCalories
        self.maxCalories = maxCalories
        self.sort = sort
    }
    
    init() {
        time = nil
        cuisine = []
        diet = nil
        type = []
        intolerances = []
        includeIngredients = []
        excludeIngredients = []
        maxCalories = nil
        maxCalories = nil
        sort = nil
    }
}
