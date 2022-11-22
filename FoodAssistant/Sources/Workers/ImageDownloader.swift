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
    ///   - urlRequest: url запрос
    ///   - completion: захватывает данные / ошибку
    func fetchImage(urlRequest: URLRequest,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void)
}

/// Сервис загрузки изображений
final class ImageDownloader { }

// MARK: - ImageDownloadProtocol
extension ImageDownloader: ImageDownloadProtocol {
    func fetchImage(urlRequest: URLRequest, completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, responce, error) in
            guard responce != nil else {
                completion(.failure(.notInternet))
                return
            }
            guard let data = data,
                  error == nil else {
                completion(.failure(.failedToLoadImage))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

