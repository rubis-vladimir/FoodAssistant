//
//  RecipeRequest.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

/// #Запросы рецептов
enum RecipeRequest {
    /// Общий запрос рецептов по параметрам
    ///  - Parameters:
    ///   - parameters: параметры запроса
    ///   - number: количество рецептов
    ///   - query: поиск по названию рецепта
    case complex(_ parameters: RecipeFilterParameters,
                 _ number: Int,
                 _ query: String?)
    
    case byIngredients(_ titles: [String],
                       _ number: Int)
    
    case byId(_ ids: [Int])
    
    /// Запрос рецепта по ингредиентам
    ///  - Parameters:
    ///   - ingridients: массив ингредиентов
    ///   - number: количество рецептов
    case findIngredient(_ query: String?)
}

extension RecipeRequest {
    func downloadRecipes(with service: DataFetcherProtocol,
                         completion: @escaping (Result<RecipeResponce, DataFetcherError>) -> Void) {
        fetchObject(with: service, completion: completion)
    }
    
    func downloadIds(with service: DataFetcherProtocol,
                     completion: @escaping (Result<[DTORecipeId], DataFetcherError>) -> Void) {
        fetchObject(with: service, completion: completion)
    }
    
    func downloadById(with service: DataFetcherProtocol,
                      completion: @escaping (Result<[Recipe], DataFetcherError>) -> Void) {
        fetchObject(with: service, completion: completion)
    }
    
    func findIngredient(with service: DataFetcherProtocol,
                        completion: @escaping (Result<DTOIngredientResponce, DataFetcherError>) -> Void) {
        fetchObject(with: service, completion: completion)
    }
    
    /// Обращается к сетевому сервису для загрузки рецептов
    ///  - Parameters:
    ///   - service: используемый сервис для запроса из сети
    ///   - completion: захватывает модель ответ с рецептами / ошибку
    private func fetchObject<T: Codable>(with service: DataFetcherProtocol,
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
extension RecipeRequest: RequestBuilding {
    
    var baseUrl: String { "api.spoonacular.com" }
    
    var path: String {
        switch self {
        case .complex:
            return "/recipes/complexSearch"
        case .byIngredients:
            return "/recipes/findByIngredients"
        case .byId:
            return "/recipes/informationBulk"
        case .findIngredient:
            return "/food/ingredients/search"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .complex(parameters, number, query):
            
            return [
                URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue),
                URLQueryItem(name: "addRecipeNutrition", value: "true"),
                URLQueryItem(name: "fillIngredients", value: "true"),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "number", value: String(number)),
                URLQueryItem(name: "maxReadyTime", value: String(parameters.time ?? 1000)),
                URLQueryItem(name: "type", value: parameters.type.convertStringArrayToString()),
                URLQueryItem(name: "cuisine", value: parameters.cuisine.convertStringArrayToString()),
                URLQueryItem(name: "diet", value: parameters.diet),
                URLQueryItem(name: "intolerances", value: parameters.intolerances.convertStringArrayToString()),
                URLQueryItem(name: "includeIngredients", value: parameters.includeIngredients.convertStringArrayToString()),
                URLQueryItem(name: "excludeIngredients", value: parameters.excludeIngredients.convertStringArrayToString()),
                URLQueryItem(name: "minCalories", value: String(parameters.minCalories ?? 0)),
                URLQueryItem(name: "maxCalories", value: String(parameters.maxCalories ?? 10000)),
                URLQueryItem(name: "sort", value: parameters.sort)
            ]
            
        case let .byIngredients(ingredientTitles, number):
            return [
                URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue),
                URLQueryItem(name: "ingredients", value: ingredientTitles.convertStringArrayToString()),
                URLQueryItem(name: "number", value: String(number)),
            ]
            
        case let .byId(ids):
            return [
                URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue),
                URLQueryItem(name: "includeNutrition", value: "true"),
                URLQueryItem(name: "ids", value: ids.map(String.init).convertStringArrayToString())
            ]
            
        case let .findIngredient(query):
            return [
                URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "number", value: "1")
            ]
        }
    }
    
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { ["Content-Type": "application/json"] }
}
