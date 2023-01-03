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
        case .time: return "Time".localize()
        case .dishType: return "Type dish".localize()
        case .region: return "Region".localize()
        case .diet: return "Diet".localize()
        case .calories: return "Calories".localize()
        case .includeIngredients: return "Include ingredients".localize()
        case .excludeIngredients: return "Exclude Ingredients".localize()
        }
    }
}
