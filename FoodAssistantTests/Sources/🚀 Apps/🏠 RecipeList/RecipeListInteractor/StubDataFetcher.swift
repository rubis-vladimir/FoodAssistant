//
//  StubDataFetcher.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubDataFetcher: DataFetcherProtocol {
    func fetchObject<T>(urlRequest: URLRequest, completion: @escaping (Result<T, FoodAssistant.DataFetcherError>) -> Void) where T : Decodable {
        <#code#>
    }
}
