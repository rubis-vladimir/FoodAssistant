//
//  StubTranslateService.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubTranslateService: Translatable {
    
    var ruRecipe: [Recipe]
    var ruText: TranslateResponce?
    var enText: TranslateResponce?
    var error: DataFetcherError?
    var target: String?
    
    init(ruRecipe: [Recipe] = [],
         ruText: TranslateResponce? = nil,
         enText: TranslateResponce? = nil,
         error: DataFetcherError? = nil,
         target: String? = nil) {
        self.ruRecipe = ruRecipe
        self.ruText = ruText
        self.enText = enText
        self.error = error
        self.target = target
    }
    
    func fetchTranslate(recipes: [Recipe],
                        sourse: String,
                        target: String,
                        completion: @escaping (Result<[Recipe], DataFetcherError>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(ruRecipe))
        }
    }
    
    func translate(with texts: [String],
                   source: String,
                   target: String,
                   completion: @escaping (Result<TranslateResponce, DataFetcherError>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let ruText = ruText,
                    target == "ru" {
            completion(.success(ruText))
        } else if let enText = enText,
                    target == "en" {
            completion(.success(enText))
        }
    }
}
