//
//  DataFetcherService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

/// Сервис работы с запросами
final class DataFetcherService {
    
    private let dataFetcher: DataFetcherProtocol
    private let imageDownloader: ImageDownloadProtocol
    
    init(dataFetcher: DataFetcherProtocol
         ,imageDownloader: ImageDownloadProtocol) {
        self.dataFetcher = dataFetcher
        self.imageDownloader = imageDownloader
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

extension DataFetcherService: DataFetcherImageManagement {
    func fetchRecipeImage(_ imageName: String, completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader, completion: completion)
    }
    
    func fetchIngredientImage(_ imageName: String, size: ImageSize, completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .ingredient(imageName: imageName, size: size)
            .download(with: imageDownloader, completion: completion)
    }
}
