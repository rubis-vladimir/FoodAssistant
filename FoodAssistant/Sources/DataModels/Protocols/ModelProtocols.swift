//
//  ModelProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import Foundation

/// #Протокол описывающий рецепт
protocol RecipeProtocol {
    /// Идентификатор рецепта
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
    /// Флаг любимого рецепта
    var isFavorite: Bool { get }
}


/// #Протокол описывающий ингредиент
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
    var unit: String { get }
    /// Флаг использования при приготовлении
    var toUse: Bool { get }
}

/// #Протокол описывающий питательное вещество
protocol NutrientProtocol {
    /// Название
    var name: String { get }
    /// Количество
    var amount: Float { get }
    /// Единицы измерения
    var unit: String { get }
}

/// #Протокол описывающий шаг в инструкции по приготовлению
protocol InstructionStepProtocol {
    /// Номер шага
    var number: Int { get }
    /// Текстовая информация
    var step: String { get }
}
