//
//  SpyRecipeFilterView.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 12.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyRecipeFilterView: RecipeFilterViewable {
    
    var text: String?
    var updateCount = 0
    
    func updateCV(dictModels: [FilterParameters : [TagModel]]) {
        updateCount += 1
    }
    
    func update(section: Int) {
        updateCount += 1
    }
    
    func updateSearch(text: String) {
        self.text = text
    }
    
    func getSearchText() -> String? {
        text
    }
    
    func showTFAlert(parameter: FilterParameters,
                     text: String) {
        self.text = text
    }
}
