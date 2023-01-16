//
//  StubDataFetcher.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubDataFetcher: DataFetcherProtocol {

    var error: DataFetcherError?
    var models: [Recipe]

    init(error: DataFetcherError? = nil,
         models: [Recipe] = []) {
        self.error = error
        self.models = models
    }

    func fetchObject<T>(urlRequest: URLRequest,
                        completion: @escaping (Result<T, DataFetcherError>) -> Void) where T: Decodable {
        if let error = error {
            completion(.failure(error))
        } else if let responce = RecipeResponce(results: models) as? T {
            completion(.success(responce))
        } else if let responce = TranslateResponce(translations: []) as? T {
            completion(.success(responce))
        } else {
            completion(.failure(.decodingError))
        }
    }
}
