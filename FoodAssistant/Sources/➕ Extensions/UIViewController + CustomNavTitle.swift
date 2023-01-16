//
//  UIViewController + CustomNavTitle.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.12.2022.
//

import UIKit

extension UIViewController {

    /// Создает кастомный лейбл для `NavBar`
    /// - Parameter title: текст лейбла
    func createNavTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = Fonts.navTitle
        return label
    }
}
