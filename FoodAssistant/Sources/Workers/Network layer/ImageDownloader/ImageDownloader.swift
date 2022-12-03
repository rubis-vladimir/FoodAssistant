//
//  ImageDownloadService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 20.11.2022.
//

import Foundation

/// Протокол загрузки изображений из сети
protocol ImageDownloadProtocol {
    /// Получает данные изображения
    ///  - Parameters:
    ///   - url: url
    ///   - completion: захватывает данные / ошибку
    func fetchImage(url: URL,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// #Сервис загрузки изображений
final class ImageDownloader { }

// MARK: - ImageDownloadProtocol
extension ImageDownloader: ImageDownloadProtocol {
    func fetchImage(url: URL,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                completion(.failure(.failedToLoadImage))
                return
            }
            completion(.success(data))
        }
    }
}
