//
//  IngredientViewModel.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 18.12.2022.
//

import Foundation

struct IngredientViewModel: Equatable, Hashable {
    /// Идентификатор ингредиента
    var id: Int
    /// Название изображения ингредиента
    var image: String?
    /// Название ингредиента
    var name: String
    /// Количество
    var amount: Float
    /// Единицы измерения
    var unit: String
    /// Флаг использования
    var toUse: Bool
    /// Для Шоп-листа
    var isCheck: Bool = false
    
    init(ingredient: IngredientProtocol) {
        self.id = ingredient.id
        self.image = ingredient.image
        self.name = ingredient.name
        self.amount = ingredient.amount
        self.unit = ingredient.unit
        self.toUse = ingredient.toUse
    }
    
    init(id: Int,
         image: String?,
         name: String,
         amount: Float,
         unit: String) {
        self.id = id
        self.image = image
        self.name = name
        self.amount = amount
        self.unit = unit
        self.toUse = false
    }
    
    static func ==(lhs: IngredientViewModel, rhs: IngredientViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
