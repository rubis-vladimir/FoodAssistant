//
//  RecipeViewModel.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 20.11.2022.
//

import Foundation

/// #Вью-модель рецепта
struct RecipeViewModel {
    /// Идентификатор
    var id: Int
    /// Название рецепта
    var title: String
    /// Количество ингредиентов
    var ingredientsCount: Int
    /// Название изображения
    var imageName: String?
    /// Флаг избранного рецепта
    var isFavorite: Bool
    /// Время приготовления в минутах
    var cookingTime: String

    init(with recipe: RecipeProtocol) {
        self.id = recipe.id
        self.title = recipe.title
        self.ingredientsCount = recipe.ingredients?.count ?? 0
        self.imageName = recipe.imageName
        self.isFavorite = recipe.isFavorite
        self.cookingTime = recipe.cookingTime
    }
}
