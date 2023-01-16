//
//  StubImageDownloader.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubImageDownloader: ImageDownloadProtocol {

    var error: DataFetcherError?
    var data: Data?

    init(error: DataFetcherError? = nil,
         data: Data? = nil) {
        self.error = error
        self.data = data
    }

    func fetchImage(url: URL,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        if let data = data {
            completion(.success(data))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}
