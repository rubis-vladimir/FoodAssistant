//
//  [String] + String.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

extension Array where Element == String {
    
    /// Преобразует массив строк в одну строку
    func convertStringArrayToString() -> String {
        let array = self
        var finalString: String = ""
        for string in array {
            if string != array.last {
                finalString += string.lowercased() + ","
            } else {
                finalString += string.lowercased()
            }
        }
        return finalString
    }
}
