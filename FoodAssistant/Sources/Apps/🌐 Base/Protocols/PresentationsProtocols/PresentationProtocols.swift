//
//  ImagePresentation.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.12.2022.
//

import Foundation

/// #Типы изображений
enum TypeOfImage {
    /// Изображение рецепта
    case recipe
    /// Изображение ингредиента
    case ingredient
}

/// #Протокол запроса изображения к слою презентации
protocol ImagePresentation {
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - type: тип загружаемой картинки
    ///   - completion: захватывает данные изображения
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Data) -> Void)
}

/// #Протокол для обновления данных, которое должно происходить при появлении вью на экране
protocol ViewAppearable {
    /// Сообщить, что вью появляется на экране
    func viewAppeared()
}

/// #Протокол передачи UI-ивента при нажатии на кнопку назад
protocol BackTapable {
    /// Ивент нажатия кнопки назад
    func didTapBackButton()
}
