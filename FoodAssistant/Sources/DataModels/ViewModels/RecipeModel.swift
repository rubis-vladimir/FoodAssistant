//
//  RecipeCellModel.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 20.11.2022.
//

import Foundation

// Упрощенная модель рецепта для отображения
struct ShortRecipeViewModel {
    /// Идентификатор
    var id: Int
    /// Название рецепта
    var title: String
    /// Количество ингредиентов
    var ingredientsCount: Int
    /// Название изображения
    var imageName: String?
    /// Флаг отнесения к любимым рецептам
    var isFavorite: Bool
    /// Время приготовления в минутах
    var cookingTime: String
}
