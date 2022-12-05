//
//  DetailInfoInteractor.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол управления бизнес логикой модуля
protocol DetailInfoBusinessLogic {
    
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImageRecipe(_ imageName: String,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    
    /// Получить изображения из сети/кэша
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - size: размер изображения
    ///   - completion: захватывает данные изображения / ошибку
    func fetchImageIngredients(_ imageName: String,
                               size: ImageSize,
                               completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// #Слой бизнес логике модуля
final class DetailInfoInteractor {
    private let imageDownloader: ImageDownloadProtocol
    
    
    init(imageDownloader: ImageDownloadProtocol) {
        self.imageDownloader = imageDownloader
    }
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
