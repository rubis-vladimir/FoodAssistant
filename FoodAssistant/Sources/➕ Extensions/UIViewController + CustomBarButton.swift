//
//  UIViewController + CustomBarButton.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 14.11.2022.
//

import UIKit

extension UIViewController {
    
    /// Создает кастомную кнопку
    ///  - Parameters:
    ///   - icon: изображение
    ///   - selector: действие
    ///  - Returns: кастомная кнопка
    func createCustomBarButton(icon: Icons,
                               selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(icon.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)

        return UIBarButtonItem(customView: button)
    }
}
