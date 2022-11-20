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
    var cookingTime: String
    var isFavorite: Bool
    var ingredientsCount: Int
    var imageData: Data?
}
