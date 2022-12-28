//
//  DataFetcherError.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

/// #Варианты ошибок сетевого слоя
enum DataFetcherError: Error {
    case invalidUrl
    case invalidResponseCode
    case encodingError
    case decodingError
    
    case failedToLoadData
    case failedToLoadImage
    case failedToTranslate
    
    case wrongStatusCode
    case notInternet
    case noCorrectNumber
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


//enum

