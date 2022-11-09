//
//  LocalizedError.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

/// Протокол описания ошибки
protocol LocalizedError : Error {
    /// Заголовок ошибки
    var errorTitle: String? { get }
    /// Причина ошибки
    var failureReason: String? { get }
    /// Предложения по восстановлению
    var recoverySuggestion: String? { get }
}
