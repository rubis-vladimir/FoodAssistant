//
//  RecipeRequest.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation

enum RecipeRequest<T:Codable> {
    case complexSearch(_ parameters: FilterParameters, _ number: Int, _ query: String?)
    case findByNutrients(parameters: T)
    case findByIngredients(parameters: T)
}


extension RecipeRequest: RequestBuilding {
    var baseUrl: String { "api.spoonacular.com" }
    
    var path: String {
        switch self {
        case .complexSearch:
            return "/recipes/complexSearch"
        case .findByNutrients:
            return "/recipes/findByNutrients"
        case .findByIngredients:
            return "/recipes/findByIngredients"
        }
    }
    
    var queryItems: [URLQueryItem] {
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
            URLQueryItem(name: "maxCalories", value: maxCalories),
            URLQueryItem(name: "sort", value: parameters.sort)
            ]
        case .findByNutrients(parameters: let parameters):
            return []
        case .findByIngredients(parameters: let parameters):
        return [
            URLQueryItem(name: "apiKey", value: APIKeys.spoonacular.rawValue)
        ]
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: HTTPHeaders? { ["Content-Type": "application/json"] }

    var parameters: Parameters? { nil }
}
