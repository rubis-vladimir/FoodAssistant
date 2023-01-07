//
//  StubRecipeFilterPresenter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubRecipeFilterPresenter: RecipeFilterBusinessLogicDelegate {
    
    var section: Int = 0
    
    func update(section: Int) {
        self.section = section
    }
}
