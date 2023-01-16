//
//  HeaderSectionModel.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 03.12.2022.
//

import UIKit

/// #Модель для конфигурации заголовка секции
struct HeaderSectionModel {
    /// Название секции
    var title: String
    /// Первое изображение кнопки
    var firstImage: UIImage?
    /// Второе изображение кнопки
    var secondImage: UIImage?
    /// Действие
    var action: ((Int) -> Void)?
}
