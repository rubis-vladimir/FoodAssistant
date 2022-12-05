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
    case complexSearch(_ parameters: RecipeFilterParameters,
                       _ number: Int,
                       _ query: String?)
    
    /// Запрос рецепта по ингредиентам
    ///  - Parameters:
    ///   - ingridients: массив ингредиентов
    ///   - number: количество рецептов
    case findByIngredients(_ ingridients: [String],
                           _ number: Int)
    
    /// Запрос случайных рецептов
    ///  - Parameters:
    ///   - number: количество рецептов
    ///   - tags: теги для рецептов
    case random(_ number: Int,
                tags: [String])
}

extension RecipeRequest {
    /// Обращается к сетевому сервису для загрузки рецептов
    ///  - Parameters:
    ///   - service: используемый сервис для запроса из сети
    ///   - completion: захватывает модель ответ с рецептами / ошибку
    func download(with service: DataFetcherProtocol,
                  completion: @escaping (Result<RecipeResponce, DataFetcherError>) -> Void) {
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
        case .complexSearch:
            return "/recipes/complexSearch"
        case .findByIngredients:
            return "/recipes/findByIngredients"
        case .random:
            return "/recipes/random"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .complexSearch(parameters, number, query):
            let maxCalories = parameters.maxCalories == nil ? "10000" : String(parameters.maxCalories!)
            return [
                URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue),
                URLQueryItem(name: "addRecipeNutrition", value: "true"),
                URLQueryItem(name: "fillIngredients", value: "true"),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "number", value: String(number)),
                URLQueryItem(name: "type", value: parameters.type),
                URLQueryItem(name: "cuisine", value: parameters.cuisine),
                URLQueryItem(name: "diet", value: parameters.diet),
                URLQueryItem(name: "intolerances", value: parameters.intolerances.convertStringArrayToString()),
                URLQueryItem(name: "includeIngredients", value: parameters.includeIngredients.convertStringArrayToString()),
                URLQueryItem(name: "excludeIngredients", value: parameters.excludeIngredients.convertStringArrayToString()),
                URLQueryItem(name: "maxCalories", value: maxCalories),
                URLQueryItem(name: "sort", value: parameters.sort)
            ]
        case let .findByIngredients(ingredients, number):
            return [
                URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue),
                URLQueryItem(name: "number", value: String(number)),
                URLQueryItem(name: "ingredients", value: ingredients.convertStringArrayToString())
            ]
        case let .random(number, tags):
            return [
                URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue),
                URLQueryItem(name: "number", value: String(number)),
                URLQueryItem(name: "tags", value: tags.convertStringArrayToString())
            ]
        }
    }
    
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { ["Content-Type": "application/json"] }
}
