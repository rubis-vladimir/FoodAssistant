//
//  Constants.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.11.2022.
//

import UIKit

// Константы
struct AppConstants {
    /// Отступы по дефолту
    static let padding: CGFloat = 16
    
    static let edgeInsert = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
    
    enum Shadow: ShadowProtocol {
        case defaultOne, defaultTwo
        
        var color: UIColor {
            switch self {
            case .defaultOne: return Palette.shadowColor.color
            case .defaultTwo: return Palette.shadowColor2.color
            }
        }
        var radius: CGFloat { 3.0 }
        var opacity: Float { 0.65 }
        var offset: CGSize { CGSize(width: 0.0, height: 1.0) }
    }
}


