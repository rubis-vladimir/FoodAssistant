//
//  FetchImageProtocols.swift
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

/// #Протокол получения изображения из слоя бизнес-логики
protocol ImageBusinessLogic {
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - type: тип загружаемой картинки
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImage(_ imageName: String,
                    type: TypeOfImage,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}
