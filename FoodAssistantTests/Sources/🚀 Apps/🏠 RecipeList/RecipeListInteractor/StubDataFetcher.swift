//
//  StubDataFetcher.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubDataFetcher<T: Decodable>: DataFetcherProtocol {
    
    var error: DataFetcherError?
    var model: T?
    
    init(error: DataFetcherError? = nil,
         model: T? = nil) {
        self.error = error
        self.model = model
    }
    
    func fetchObject<T>(urlRequest: URLRequest,
                        completion: @escaping (Result<T, DataFetcherError>) -> Void) where T: Decodable {
        if let model = model {
            completion(.success(model))
        } else {
            
        }
    }
}
