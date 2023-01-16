//
//  NetworkDataFetcher.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

/// #Протокол получения и декодирования данных из сети
protocol DataFetcherProtocol {

    /// Создает и направляет запрос в сеть для получения данных
    ///  - Parameters:
    ///     - requestBuilder: конструктор запроса
    ///     - responce: замыкание для захвата данных/ошибки
    func fetchObject<T: Decodable>(urlRequest: URLRequest,
                                   completion: @escaping (Result<T, DataFetcherError>) -> Void)
}

/// #Сервис работы с сетью
final class NetworkDataFetcher {

    static let shared = NetworkDataFetcher()

    private init() { }

    /// Запрос данных из сети
    ///  - Parameters:
    ///   - request: http-запрос
    ///   - response: ответ, захватывает данные/ошибку
    private func fetchData(request: URLRequest,
                           completion: @escaping (Result<Data, DataFetcherError>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, responce, error) in

            if let httpResponse = responce as? HTTPURLResponse {
                guard (200..<300) ~= httpResponse.statusCode else {
                    completion(.failure(.invalidResponceCode))
                    return
                }
            }

            guard let data = data,
                  error == nil  else {
                completion(.failure(.dataLoadingError))
                return
            }
            completion(.success(data))
        }.resume()
    }

    /// Декодирует данные в модель типа `T`
    ///  - Parameters:
    ///   - data: json-данные
    ///   - response: ответ, захватывает модель данных/ошибку
    private func decode<T: Decodable>(data: Data,
                                      completion: @escaping (Result<T, DataFetcherError>) -> Void) {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedObject))
        } catch {
            completion(.failure(.decodingError))
        }
    }
}

// MARK: - DataFetcherProtocol
extension NetworkDataFetcher: DataFetcherProtocol {
    func fetchObject<T: Decodable>(urlRequest: URLRequest,
                                   completion: @escaping (Result<T, DataFetcherError>) -> Void) {
        fetchData(request: urlRequest) { [weak self] result in
            switch result {
            case .success(let data):
                self?.decode(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
