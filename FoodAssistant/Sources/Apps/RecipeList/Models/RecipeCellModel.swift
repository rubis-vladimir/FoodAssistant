//
//  RecipeCellModel.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 20.11.2022.
//

import Foundation

struct RecipeCellModel {
    var id: Int
    var titleRecipe: String
    var readyInMinutes: Int
    var isFavorite: Bool
    var ingredientsCount: Int
    var imageName: String? 
    
    var cookingTime: String {
        let hours = readyInMinutes / 60
        let minutes = readyInMinutes % 60
        return hours > 0 ? "\(hours) ч \(minutes) мин" : "\(minutes) мин"
    }
}
