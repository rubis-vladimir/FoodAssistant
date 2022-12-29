//
//  ViewableProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 29.12.2022.
//

import Foundation

/// #Протокол демонстрации ошибки
protocol ErrorShowable {
    
    /// Показывает ошибку
    /// - Parameter error: ошибка
    func show(error: Error)
}
