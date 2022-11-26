//
//  RecipeRequest.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

/// Варианты запросов рецептов
enum RecipeRequest {
    case complexSearch(_ parameters: RecipeFilterParameters, _ number: Int, _ query: String?)
    case findByIngredients(_ ingridients: [String], _ number: Int)
    case random(_ number: Int, tags: [String])
}

extension RecipeRequest {
    /// Обращается к сетевому сервису для загрузки рецептов
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
