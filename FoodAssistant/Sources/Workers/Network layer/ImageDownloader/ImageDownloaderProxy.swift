//
//  ImageDownloadService.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 22.11.2022.
//

import Foundation

/// Заместитель сервиса загрузки изображений (работает с cache)
final class ImageDownloaderProxy {
    
    private let imageDownloader: ImageDownloadProtocol
    private var imageCache: ImageCacheProtocol
    
    init(imageDownloader: ImageDownloadProtocol,
         imageCache: ImageCacheProtocol) {
        self.imageDownloader = imageDownloader
        self.imageCache = imageCache
    }
}

// MARK: - ImageDownloadProtocol
extension ImageDownloaderProxy: ImageDownloadProtocol {
    func fetchImage(url: URL,
                    completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        if let imageData = imageCache[url] {
            completion(.success(imageData))
        } else {
            imageDownloader.fetchImage(url: url) { [weak self] result in
                switch result {
                case .success(let imageData):
                    self?.imageCache[url] = imageData
                    completion(.success(imageData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
