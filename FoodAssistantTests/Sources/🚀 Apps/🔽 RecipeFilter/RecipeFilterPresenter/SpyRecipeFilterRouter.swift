//
//  SpyRecipeFilterRouter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 12.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyRecipeFilterRouter: RecipeFilterRouting {
    
    var count = 0
    
    func routeToBack() {
        count += 1
    }
}
