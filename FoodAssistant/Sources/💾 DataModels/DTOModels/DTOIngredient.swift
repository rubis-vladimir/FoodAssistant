//
//  DTOIngredient.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.12.2022.
//

import Foundation

/// #Модель ответа по запросу ингредиентов
struct DTOIngredientResponce: Codable, Hashable {
    var results: [DTOIngredient]
}

/// #Модель ингредиента при запросе его из сети
struct DTOIngredient: Codable, Hashable {
    var id: Int
    var name: String
    var image: String?
}
