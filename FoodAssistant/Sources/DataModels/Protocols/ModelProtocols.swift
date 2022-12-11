//
//  ModelProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import Foundation

protocol RecipeProtocol {
    
    var id: Int { get }
    /// Название рецепта
    var title: String { get }
    /// Полная готовность в мин
    var cookingTime: String { get }
    /// Количество порций
    var servings: Int { get }
    /// Изображение рецепта
    var imageName: String? { get }
    /// Массив используемых ингредиентов
    var ingredients: [IngredientProtocol]? { get }
    /// Информация по питательным веществам
    var nutrients: [NutrientProtocol]? { get }
    /// Инструкции для приготовления
    var instructions: [InstructionStepProtocol]? { get }
    
    var isFavorite: Bool { get }
    
    var inBasket: Bool { get }
}

extension RecipeProtocol {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}

protocol IngredientProtocol {
    /// Идентификатор ингредиента
    var id: Int { get }
    /// Название изображения ингредиента
    var image: String? { get }
    /// Название ингредиента
    var name: String { get }
    /// Количество
    var amount: Float { get }
    /// Единицы измерения
    var unit: String? { get }
}

protocol NutrientProtocol {
    /// Название
    var name: String { get }
    /// Количество
    var amount: Float { get }
    /// Единицы измерения
    var unit: String { get }
}

protocol InstructionStepProtocol {
    /// Номер
    var number: Int { get }
    /// Текстовая информация
    var step: String { get }
}
