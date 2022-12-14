//
//  StorageProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 12.12.2022.
//

import Foundation

/// #Цель сохранения рецепта в БД
enum TargetOfSave {
    /// Добавили в любимые рецепты
    case favorite
    /// Добавили в корзину
    case basket
}

/// #Протокол управления менеджером хранения данных для рецептов
protocol DBRecipeManagement {
    /// Получает рецепты
    ///  - Parameters:
    ///   - target: цель хранения
    ///   - completion: захватывает массив рецептов
    func fetchRecipes(for target: TargetOfSave,
                      completion: @escaping ([RecipeProtocol]) -> Void)
    
    /// Сохраняет рецепт
    ///  - Parameters:
    ///   - recipe: рецепт
    ///   - target: цель хранения
    func save(recipe: RecipeProtocol,
              for target: TargetOfSave)
    
    /// Удаляет рецепт по идентификатору
    /// - Parameters:
    ///   - id: идентификатор рецепта
    ///   - target: цель хранения
    func remove(id: Int,
                for target: TargetOfSave)
    
    /// Проверяет наличие рецепта в БД
    /// - Parameter id: идентификатор рецепта
    /// - Returns: да/нет
    func check(id: Int) -> Bool
}

/// #Протокол управления менеджером хранения данных для ингредиентов в твоем холодильнике
protocol DBIngredientsFridgeManagement {
    /// Получает ингредиенты
    ///   - Parameter completion: захватывает массив ингредиентов
    func fetchIngredients(completion: @escaping ([IngredientProtocol]) -> Void)
    
    /// Сохраняет ингредиент
    ///  - Parameter ingredient: ингредиент
    func save(ingredient: IngredientProtocol)
    
    /// Удаляет ингредиент из БД по идентификатору
    /// - Parameter id: идентификатор рецепта
    func remove(id: Int)
}
