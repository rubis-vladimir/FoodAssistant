//
//  RecipeViewModel.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.12.2022.
//

import Foundation

struct RecipeViewModel {
    /// Идентификатор
    var id: Int
    /// Название рецепта
    var title: String
    /// Полная готовность в мин
    var cookingTime: String
    /// Количество порций
    var servings: Int
    /// Изображение рецепта
    var imageName: String?
    /// Информация по питательным веществам
    var nutrients: [Nutrient]?
    /// Массив используемых ингредиентов
    var ingredients: [Ingredient]?
    /// Инструкции для приготовления
    var instructionSteps: [InstuctionStep]?

}
