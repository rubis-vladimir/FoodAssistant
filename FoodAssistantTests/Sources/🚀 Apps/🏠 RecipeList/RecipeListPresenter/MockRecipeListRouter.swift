//
//  MockRecipeListRouter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import UIKit
@testable import FoodAssistant

class MockRecipeListRouter: RecipeListRouting {
    func routeToFilter(_ flag: Bool, searchDelegate: FoodAssistant.SeachRecipesRequested) {
        
    }
    
    func routeToFilter(_ flag: Bool, search: UISearchController, searchDelegate: FoodAssistant.SeachRecipesRequested) {
        
    }
    
    func routeToDetail(model: FoodAssistant.RecipeProtocol) {
        
    }
    
}
