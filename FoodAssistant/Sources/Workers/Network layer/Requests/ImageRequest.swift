//
//  ImageRequest.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.11.2022.
//

import Foundation

/// Варианты загрузки изображений
enum ImageRequest {
    case recipe(imageName: String)
    case ingredient(imageName: String, size: ImageSize)
}

extension ImageRequest {
    /// Обращается к сервису для загрузки изображений
    func download(with service: ImageDownloadProtocol,
                  completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        guard let url = url else {
            completion(.failure(.wrongUrl))
            return
        }
        print(url.absoluteString)
        service.fetchImage(url: url, completion: completion)
    }
    
    private var baseUrl: String {
        "spoonacular.com"
    }
    
    private var path: String {
        switch self {
        case let .recipe(imageName):
            return "/recipeImages/\(imageName)"
        case let .ingredient(imageName, size):
            return "/cdn/ingredients_\(size.rawValue)/\(imageName)"
        }
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = path
        return components.url
    }
}

