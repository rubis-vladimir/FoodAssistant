//
//  DataFetcherProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.11.2022.
//

import Foundation

typealias DFM = DataFetcherTranslateManagement & DataFetcherRecipeManagement & DataFetcherImageManagement

// MARK: - Протокол управления запросами на получение рецептов
protocol DataFetcherRecipeManagement {
    /// Запрос рецепта
    ///  - Parameters:
    ///   - parameters: параметры запроса
    ///   - completion: захватывает модель рецептов / ошибку
    func fetchComplexRecipe(_ parameters: RecipeFilterParameters,
                            _ number: Int, _ query: String?,
                            completion: @escaping (Result<RecipeModel, DataFetcherError>) -> Void)
    
    func fetchRandomRecipe(number: Int,
                           tags: [String],
                           completion: @escaping (Result<RecipeModel, DataFetcherError>) -> Void)
}

// MARK: - Протокол управления запросами на перевод
protocol DataFetcherTranslateManagement {
    /// Запрос на перевод текста
    ///  - Parameters:
    ///   - parameters: название изображения
    ///   - completion: захватывает переведенную модель / ошибку
    func translate(with parameters: TranslateParameters,
                   completion: @escaping (Result<Translate, DataFetcherError>) -> Void)
}

// MARK: - Протокол управления с запросами на перевод
protocol DataFetcherImageManagement {
    /// Запрос на загрузку изображения рецепта
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные / ошибку
    func fetchRecipeImage(_ imageName: String,
                   completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    /// Запрос на загрузку изображения ингредиента
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - size: размер изображения
    ///   - completion: захватывает данные / ошибку
    func fetchIngredientImage(_ imageName: String, size: ImageSize,
                   completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}
