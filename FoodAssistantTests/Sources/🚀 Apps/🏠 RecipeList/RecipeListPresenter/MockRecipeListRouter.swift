//
//  MockRecipeListRouter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class MockRecipeListRouter: RecipeListRouting {
    func routeToDetail(model: FoodAssistant.RecipeProtocol) {
        
    }
    
    func routeToFilter(_ flag: Bool,
                       searchDelegate: FoodAssistant.SeachRecipesRequested) {
        
    }
}
