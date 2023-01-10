//
//  SpyRecipeListView.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import UIKit
@testable import FoodAssistant

class SpyRecipeListView: RecipeListViewable {
    
    var text: String = ""
    var countUpdate = 0
    var error: FoodAssistant.RecoverableError?
    
    init(text: String,
         countUpdate: Int = 0) {
        self.text = text
        self.countUpdate = countUpdate
    }
    
    func updateCV(with: [RecipeModelsDictionary]) {
        countUpdate += 1
    }
    
    func getSearchText() -> String? {
        return text
    }
    
    func updateItems(indexPaths: [IndexPath]) {
        countUpdate += 1
    }
    
    func show(rError: FoodAssistant.RecoverableError) {
        error = rError
    }
}
 
