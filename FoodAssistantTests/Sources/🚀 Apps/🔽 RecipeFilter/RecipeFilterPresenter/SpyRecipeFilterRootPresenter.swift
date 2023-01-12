//
//  SpyRecipeFilterRootPresenter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 12.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyRecipeFilterRootPresenter: SeachRecipesRequested {
    
    var text: String?
    var parameters: RecipeFilterParameters?
    
    func search(with parameters: RecipeFilterParameters,
                text: String) {
        self.text = text
        self.parameters = parameters
    }
}
