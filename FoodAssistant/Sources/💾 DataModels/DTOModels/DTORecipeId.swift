//
//  DTORecipeId.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.12.2022.
//

import Foundation

/// #Модель Id рецепта при запросе по ингредиентам
struct DTORecipeId: Codable, Hashable {
    var id: Int
}
