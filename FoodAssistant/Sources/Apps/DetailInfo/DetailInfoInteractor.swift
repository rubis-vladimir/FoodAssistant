//
//  DetailInfoInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол управления бизнес логикой модуля
protocol DetailInfoBusinessLogic {
    func fetchImageRecipe(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    func fetchImageIngredients(_ imageName: String, size: ImageSize,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// #Слой бизнес логике модуля
final class DetailInfoInteractor {
    private let imageDownloader: ImageDownloadProtocol
    
    
    init(imageDownloader: ImageDownloadProtocol) {
        self.imageDownloader = imageDownloader
    }
    /// Тут настройка Сервисов
}

// MARK: - BusinessLogic
extension DetailInfoInteractor: DetailInfoBusinessLogic {
    func fetchImageRecipe(_ imageName: String, 
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader,
                      completion: completion)
    }
    
    func fetchImageIngredients(_ imageName: String, size: ImageSize,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
       
        ImageRequest
            .ingredient(imageName: imageName,
                        size: size)
            .download(with: imageDownloader,
                      completion: completion)
    }
}
