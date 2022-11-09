//
//  DataFetcherError.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

/// Варианты ошибок сетевого слоя
enum DataFetcherError: Error {
    case failedToEncode
    case failedToDecode
    case failedToLoadData
    case failedToTranslate
    case wrongUrl
    case wrongStatusCode
}

// MARK: - LocalizedError
extension DataFetcherError: LocalizedError {
    var errorTitle: String? {
        ""
    }
    
    var failureReason: String? {
        ""
    }
    
    var recoverySuggestion: String? {
        ""
    }
}


