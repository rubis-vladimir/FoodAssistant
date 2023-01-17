//
//  DataFetcherError.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

/// #Варианты ошибок
enum DataFetcherError: Error {
    /// Некорректный URL
    case invalidUrl
    /// Некорректный статус-код
    case invalidResponceCode
    /// Ошибка кодирования
    case encodingError
    /// Ошибка декодирования
    case decodingError
    /// Ошибка загрузки данных
    case dataLoadingError
    /// Ошибка загрузки изображения
    case imageLoadingError
    /// Ошибка перевода
    case translateError
    /// Некорректный номер
    case invalidNumber
    /// Данные не предоставлены
    case notDataProvided
    /// Результатов нет
    case noResults
}

// MARK: - LocalizedError
extension DataFetcherError: LocalizedError {
    var errorTitle: String? {
        switch self {
        case .invalidResponceCode:
            return "No Internet Connection".localize()
        case .noResults:
            return "No Results".localize()
        default:
            return "Error".localize()
        }
    }

    var failureReason: String? {
        switch self {
        case .invalidResponceCode:
            return nil
        case .translateError:
            return "Unfortunately, it was not possible to localize (translate) the data".localize()
        case .notDataProvided:
            return "Not all data provided".localize()
        case .invalidNumber:
            return "Invalid quantity, must be entered in numeric format".localize()
        default:
            return "Something went wrong".localize()
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidResponceCode:
            return "Please check your internet connection and try again".localize()
        case .invalidNumber:
            return "Please, enter again".localize()
        case .notDataProvided:
            return "Please, enter name, amount".localize()
        case .dataLoadingError, .noResults:
            return "Please, try again".localize()
        default:
            return "Information sent to support. We will deal with this problem in the near future".localize()
        }
    }
}
