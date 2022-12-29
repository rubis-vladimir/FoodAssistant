//
//  DataFetcherError.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

/// #Варианты ошибок сетевого слоя
enum NetworkFetcherError: Error {
    case invalidUrl
    case invalidResponseCode(Int)
    case encodingError
    case decodingError
    case dataLoadingError
    case imageLoadingError
    case translateError
    
    case noCorrectNumber
    case noResults
}

// MARK: - LocalizedError
extension NetworkFetcherError: LocalizedError {
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


//enum

