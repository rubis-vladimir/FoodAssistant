//
//  BusinessLogicProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 14.12.2022.
//

import Foundation

/// #Протокол получения изображения из слоя бизнес-логики
protocol ImageBusinessLogic {
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - type: тип загружаемой картинки
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Result<Data, NetworkFetcherError>) -> Void)
}

/// #Протокол получения рецепта
protocol RecipeReceived {
    
    /// Получить рецепт по идентификатору
    ///  - Parameters:
    ///   - id: идентификатор
    ///   - completion: захватывает рецепт
    func getRecipe(id: Int,
                   completion: @escaping (RecipeProtocol) -> Void)
}

protocol RecipeRemovable {
    /// Удалить рецепт
    /// - Parameter id: идентификатор рецепта
    func removeRecipe(id: Int)
}

protocol IngredientFetchable {
    /// Получить ингредиенты
    /// - Parameter completion: захватывает вьюмодели ингредиентов
    func fetchIngredients(completion: @escaping ([IngredientViewModel]) -> Void)
}

protocol InBasketAdded {
    /// Добавить в корзину
    /// - Parameter id: идентификатор рецепта
    func addToBasket(id: Int)
}
