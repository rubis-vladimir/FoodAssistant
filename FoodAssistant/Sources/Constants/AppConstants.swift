//
//  Constants.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.11.2022.
//

import UIKit

/// #Константы
struct AppConstants {
    /// Отступ
    static let padding: CGFloat = 16
    /// Радиус скругления
    static let cornerRadius: CGFloat = 20
    /// Расстояния от краев
    static let edgeInsertImageButton = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
    /// Расстояния от краев для секции
    static let edgeInsertForSection = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    /// Минимальное количество рецептов в запросе
    static let minRequestAmount = 2
    /// Высота заголовка по дефолту
    static let heightHeader: CGFloat = 45
    
    /// Тени
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
    
    /// Получаем дефолтный CVLayout
    static func getFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        return layout
    }
    
    /// Рассчитывает ширину ячеек коллекции
    static func calculateItemWidth(width: CGFloat,
                                   itemPerRow: CGFloat,
                                   padding: CGFloat) -> CGFloat {
        let paddingWidht = padding * (itemPerRow + 1)
        return (width - paddingWidht) / itemPerRow
    }
}
