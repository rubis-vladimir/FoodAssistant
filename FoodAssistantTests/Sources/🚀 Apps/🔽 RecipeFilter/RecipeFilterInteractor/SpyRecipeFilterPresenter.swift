//
//  StubRecipeFilterPresenter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyRecipeFilterPresenter: RecipeFilterBusinessLogicDelegate {
    
    var updateCount = 0
    
    func update(section: Int) {
        updateCount += 1
    }
}
