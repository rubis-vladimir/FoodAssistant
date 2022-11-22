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
        do {
            service.fetchImage(urlRequest: try asURLRequest(), completion: completion)
        } catch {
            guard let error = error as? DataFetcherError else { return }
            completion(.failure(error))
        }
    }
}

// MARK: - RequestBuilding
extension ImageRequest: RequestBuilding {
    var baseUrl: String {
        "spoonacular.com"
    }
    
    var path: String {
        switch self {
        case .recipe(let imageName):
           return "/recipeImages/\(imageName)"
        case let .ingredient(imageName, size):
           return "/cdn/ingredients_\(size)/\(imageName)"
        }
    }
    
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { nil }
}
