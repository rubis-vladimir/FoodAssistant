//
//  CALayer + Shadow + Protocol.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 14.11.2022.
//

import UIKit

/// #Протокол конфигурации тени
protocol ShadowProtocol {
    /// Цвет
    var color: UIColor { get }
    /// Радиус
    var radius: CGFloat { get }
    /// Прозрачность
    var opacity: Float { get }
    /// Сдвиг
    var offset: CGSize { get }
}

// MARK: - CALayer
extension CALayer {
    /// Добавляет тень
    ///  - Parameter shadow: данные тени
    func add(shadow: ShadowProtocol) {
        self.shadowColor = shadow.color.cgColor
        self.shadowRadius = shadow.radius
        self.shadowOpacity = shadow.opacity
        self.shadowOffset = shadow.offset
    }
}
