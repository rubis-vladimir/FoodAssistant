//
//  StubIngredientManager.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubIngredientManager: ShopListCalculatable {
    
    func getShopList(ingredients: [IngredientProtocol],
                     complection: @escaping ([IngredientViewModel]) -> Void) {
        complection( ingredients.map{ IngredientViewModel(ingredient: $0) } )
    }
}
