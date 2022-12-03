//
//  DetailInfoInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол управления бизнес логикой модуля
protocol DetailInfoBusinessLogic {
    func fetchImage(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    func fetchImage(_ imageName: String, size: ImageSize,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// #Слой бизнес логике модуля
final class DetailInfoInteractor {
    private let dataFetcher: DFM
    
    init(dataFetcher: DFM) {
        self.dataFetcher = dataFetcher
    }
    /// Тут настройка Сервисов
}

// MARK: - BusinessLogic
extension DetailInfoInteractor: DetailInfoBusinessLogic {
    func fetchImage(_ imageName: String, 
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        dataFetcher.fetchRecipeImage(imageName, completion: completion)
    }
    
    func fetchImage(_ imageName: String, size: ImageSize,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        dataFetcher.fetchIngredientImage(imageName, size: size, completion: completion)
    }
}
