//
//  BusinessLogicProtocols.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 14.12.2022.
//

import Foundation

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

/// #Протокол получения рецепта
protocol RecipeReceived {
    
    /// Получить рецепт по идентификатору
    ///  - Parameters:
    ///   - id: идентификатор
    ///   - completion: захватывает рецепт
    func getRecipe(id: Int,
                   completion: @escaping (RecipeProtocol) -> Void)
}
