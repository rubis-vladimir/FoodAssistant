//
//  UIImage + Alpha.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.11.2022.
//

import UIKit

extension UIImage {
    /// Изменяет прозрачность изображения
    ///  - Parameter value: значение alpha
    ///  - Returns: измененное изображение
    func alpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero,
             blendMode: .normal,
             alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
