//
//  ImageDownloadService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 20.11.2022.
//

import Foundation

/// #Протокол загрузки изображений из сети
protocol ImageDownloadProtocol {
    /// Получает данные изображения
    ///  - Parameters:
    ///   - url: url
    ///   - completion: захватывает данные / ошибку
    func fetchImage(url: URL,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// #Сервис загрузки изображений
final class ImageDownloader {

    static let shared = ImageDownloader()

    private init() {}
}

// MARK: - ImageDownloadProtocol
extension ImageDownloader: ImageDownloadProtocol {
    func fetchImage(url: URL,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, responce, error) in

            if let httpResponse = responce as? HTTPURLResponse {
                guard (200..<300) ~= httpResponse.statusCode else {
                    completion(.failure(.invalidResponceCode))
                    return
                }
            }

            guard let data = data,
                  error == nil else {
                completion(.failure(.dataLoadingError))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
