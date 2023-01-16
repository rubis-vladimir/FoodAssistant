//
//  SpyRecipeListRouter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import UIKit
@testable import FoodAssistant

class SpyRecipeListRouter: RecipeListRouting {

    var count = 0
    var id: Int?

    func routeToFilter(text: String, searchDelegate: SeachRecipesRequested) {
        count += 1
    }

    func routeToDetail(model: RecipeProtocol) {
        count += 1
        id = model.id
    }
}
