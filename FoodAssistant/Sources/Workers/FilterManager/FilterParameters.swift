//
//  FilterParameters.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.12.2022.
//

import Foundation

/// Параметры фильтра
enum FilterParameters: Int, CaseIterable {
    case time, dishType, region, diet, calories, includeIngredients, excludeIngredients
}

extension FilterParameters {
    var title: String {
        switch self {
        case .time: return "Время"
        case .dishType: return "Тип блюда"
        case .region: return "Вид кухни"
        case .diet: return "Диета"
        case .calories: return "Каллории"
        case .includeIngredients: return "Включить ингредиенты"
        case .excludeIngredients: return "Исключить ингредиенты"
        }
    }
}
