//
//  DTOIngredient.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.12.2022.
//

import Foundation

struct DTOIngredientResponce: Codable, Hashable {
    var results: [DTOIngredient]
}

struct DTOIngredient: Codable, Hashable {
    var id: Int
    var name: String
    var image: String?
}
