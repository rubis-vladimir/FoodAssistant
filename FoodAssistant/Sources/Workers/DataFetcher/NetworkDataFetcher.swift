//
//  NetworkDataFetcher.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

// MARK: Протокол получения данных из сети
protocol DataFetcherProtocol {
    
    /// Создает и направляет запрос в сеть для получения данных
    ///  - Parameters:
    ///     - requestBuilder: конструктор запроса
    ///     - responce: замыкание для захвата данных/ошибки
    func fetchObject<T: Decodable>(urlRequest: URLRequest,
                                 completion: @escaping (Result<T, DataFetcherError>) -> Void)
}

/// Сервис работы с сетью
final class NetworkDataFetcher {
    
    /// Запрос данных из сети
    ///  - Parameters:
    ///   - request: http-запрос
    ///   - response: ответ, захватывает данные/ошибку
    private func fetchData(request: URLRequest,
                           response: @escaping (Result<Data, DataFetcherError>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            guard responce != nil else {
                response(.failure(.notInternet))
                return
            }
            guard let data = data,
                    error == nil else {
                response(.failure(.failedToLoadData))
                return
            }
            response(.success(data))
        }.resume()
    }
    
    /// Декодирует данные в модель типа `T`
    ///  - Parameters:
    ///   - data: json-данные
    ///   - response: ответ, захватывает модель данных/ошибку
    private func decode<T: Decodable>(data: Data,
                                      response: @escaping (Result<T, DataFetcherError>) -> Void) {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            response(.success(decodedObject))
        } catch {
            response(.failure(.failedToDecode))
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
                self?.decode(data: data, response: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
