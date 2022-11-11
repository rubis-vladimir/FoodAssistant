//
//  LanguageRequest.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

import Foundation

enum LanguageRequest<T: Codable> {
    /// Перевести текст
    case translate(patameters: T)
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
    
    var queryItems: [URLQueryItem]? { nil }
    
    var method: HTTPMethod {
        switch self {
        case .translate:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .translate:
            return [
                "Authorization": "Api-Key \(APIKeys.translateAPIKey.rawValue)",
                "Content-Type": "text/plain"
            ]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .translate(parameters):
            return parameters
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = url else { throw DataFetcherError.wrongUrl }
        print(url)
        var request = URLRequest (url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach {
                request.setValue($1, forHTTPHeaderField: $0)
            }
        }
        if let parameters = parameters {
            do {
                request.httpBody = try JSONEncoder().encode(parameters)
            } catch {
                throw ( DataFetcherError.failedToEncode )
            }
        }
        return request
    }
}
