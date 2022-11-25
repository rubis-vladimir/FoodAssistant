//
//  LanguageRequest.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

/// Варианты запросов на перевод
enum LanguageRequest<T: Codable> {
    /// Перевести текст
    case translate(patameters: T)
}

extension LanguageRequest {
    /// Обращается к сетевому сервису для получения перевода
    func download<T: Decodable>(with service: DataFetcherProtocol,
                  completion: @escaping (Result<T, DataFetcherError>) -> Void) {
        do {
            service.fetchObject(urlRequest: try asURLRequest(), completion: completion)
        } catch {
            guard let error = error as? DataFetcherError else { return }
            completion(.failure(error))
        }
    }
}

// MARK: - RequestBuilding
extension LanguageRequest: RequestBuilding {
    var baseUrl: String {
        "translate.api.cloud.yandex.net"
    }
    
    var path: String {
        switch self {
        case .translate:
            return "/translate/v2/translate"
        }
    }
    
    var method: HTTPMethod { .post }
    
    var headers: HTTPHeaders? {
        return [
            "Authorization": "Api-Key \(APIKeys.translateAPIKey.rawValue)",
            "Content-Type": "text/plain"
        ]
    }
    
    var parameters: Parameters? {
        switch self {
        case let .translate(parameters):
            return parameters
        }
    }
}
