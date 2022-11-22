//
//  DataFetcherService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

typealias DFM = DataFetcherTranslateManagement & DataFetcherRecipeManagement

import Foundation

/// Протокол управления запросами на получение рецептов
protocol DataFetcherRecipeManagement {
    /// Запрос аниме
    ///  - Parameters:
    ///   - requestBuilder: конфигуратор запроса
    ///   - completion: захватывает модель Аниме / ошибку
    func fetchComplexRecipe(_ parameters: RecipeFilterParameters,
                            _ number: Int, _ query: String?,
                            completion: @escaping (Result<RecipeModel, DataFetcherError>) -> Void)
    
    func fetchRandomRecipe(number: Int,
                           tags: [String],
                           completion: @escaping (Result<RecipeModel, DataFetcherError>) -> Void)
}

/// Протокол работы с запросами на перевод
protocol DataFetcherTranslateManagement {
    /// Запрос на перевод текста
    func translate(with parameters: TranslateParameters,
                   completion: @escaping (Result<Translate, DataFetcherError>) -> Void)
}

/// Сервис работы с запросами
final class DataFetcherService {
    
    private let dataFetcher: DataFetcherProtocol
    
    init(dataFetcher: DataFetcherProtocol) {
        self.dataFetcher = dataFetcher
    }
}

// MARK: - DataFetcherServiceManagement
extension DataFetcherService: DataFetcherRecipeManagement {
    func fetchComplexRecipe(_ parameters: RecipeFilterParameters,
                            _ number: Int, _ query: String?,
                            completion: @escaping (Result<RecipeModel, DataFetcherError>) -> Void) {
        RecipeRequest
            .complexSearch(parameters, number, query)
            .download(with: dataFetcher, completion: completion)
    }
    
    func fetchRandomRecipe(number: Int,
                           tags: [String],
                           completion: @escaping (Result<RecipeModel, DataFetcherError>) -> Void) {
        RecipeRequest
            .random(number, tags: tags)
            .download(with: dataFetcher, completion: completion)
    }
}

// MARK: - DataFetcherTranslateManagement
extension DataFetcherService: DataFetcherTranslateManagement {
    func translate(with parameters: TranslateParameters,
                   completion: @escaping (Result<Translate, DataFetcherError>) -> Void) {
        LanguageRequest
            .translate(patameters: parameters)
            .download(with: dataFetcher, completion: completion)
    }
}
