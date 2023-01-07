//
//  StubImageDownloader.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubImageDownloader: ImageDownloadProtocol {
    func fetchImage(url: URL, completion: @escaping (Result<Data, FoodAssistant.DataFetcherError>) -> Void) {
        
    }
}
