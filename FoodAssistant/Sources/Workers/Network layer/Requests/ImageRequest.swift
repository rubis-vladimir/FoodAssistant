//
//  ImageRequest.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.11.2022.
//

import Foundation

/// #Варианты запросов на загрузку изображений
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
        service.fetchImage(url: url, completion: completion)
    }
}

// MARK: - RequestBuilding
extension ImageRequest: RequestBuilding {

    var baseUrl: String { "spoonacular.com" }
    
    var path: String {
        switch self {
        case let .recipe(imageName):
            return "/recipeImages/\(imageName)"
        case let .ingredient(imageName, size):
            return "/cdn/ingredients_\(size.rawValue)/\(imageName)"
        }
    }
    
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { ["Content-Type": "text/plain"] }
}


