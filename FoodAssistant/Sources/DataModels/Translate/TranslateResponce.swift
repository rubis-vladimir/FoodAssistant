//
//  Translate.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

///
struct TranslateResponce: Codable {
    var translations: [Text]
    
    struct Text: Codable {
        var text: String
    }
}

