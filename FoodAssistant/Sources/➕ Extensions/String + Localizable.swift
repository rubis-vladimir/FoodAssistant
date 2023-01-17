//
//  String + Localizable.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 29.12.2022.
//

import Foundation

extension String {

    /// Локализация
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
