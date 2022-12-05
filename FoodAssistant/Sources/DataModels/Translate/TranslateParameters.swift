//
//  TranslateParameters.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

// Модель параметров перевода
struct TranslateParameters: Codable {
    /// Идентификатор сервисного аккаунта
    var folderId: String
    /// Текст для перевода
    var texts: [String]
    /// Из какого языка
    var sourceLanguageCode: String
    /// В какой язык
    var targetLanguageCode: String
    
    enum CodingKeys: String, CodingKey {
        case folderId = "folder id"
        case texts = "texts"
        case sourceLanguageCode = "sourceLanguageCode"
        case targetLanguageCode = "targetLanguageCode"
    }
}
