//
//  ImageDownloadService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 22.11.2022.
//

import Foundation

/// Протокол управления запросами на загрузку изображений
protocol ImageDownloadManagement {
    
    /// Получа на загрузку изображений
    ///  - Parameters:
    ///   - requestBuilder: конфигуратор запроса
    ///   - completion: захватывает модель Аниме / ошибку
    func fetchRecipeImage(_ imageName: String,
                          completion: @escaping (Result<Data, DataFetcherError>) -> Void)
    func fetchIngredientImage(_ imageName: String, size: ImageSize,
                          completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}


/// Сервис загрузки изображений
final class ImageDownloadService {
    
    private let imageDownloader: ImageDownloadProtocol
    
    init(imageDownloader: ImageDownloadProtocol) {
        self.imageDownloader = imageDownloader
    }
}

// MARK: - ImageDownloadManagement
extension ImageDownloadService: ImageDownloadManagement {
    func fetchRecipeImage(_ imageName: String,
                          completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .recipe(imageName: imageName)
            .download(with: imageDownloader, completion: completion)
    }
    
    func fetchIngredientImage(_ imageName: String, size: ImageSize,
                              completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        ImageRequest
            .ingredient(imageName: imageName, size: size)
            .download(with: imageDownloader, completion: completion)
    }
}
