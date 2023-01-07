//
//  StubTranslateService.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubTranslateService: Translatable {
    func fetchTranslate(recipes: [FoodAssistant.Recipe], sourse: String, target: String, completion: @escaping (Result<[FoodAssistant.Recipe], FoodAssistant.DataFetcherError>) -> Void) {
        <#code#>
    }
    
    func translate(with texts: [String], source: String, target: String, completion: @escaping (Result<FoodAssistant.TranslateResponce, FoodAssistant.DataFetcherError>) -> Void) {
        <#code#>
    }
}
