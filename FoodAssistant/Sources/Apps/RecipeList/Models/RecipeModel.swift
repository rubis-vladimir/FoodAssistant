//
//  RecipeCellModel.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 20.11.2022.
//

import Foundation

// Упрощенная модель рецепта для отображения
struct RecipeModel {
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
    var readyInMinutes: Int
    
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
