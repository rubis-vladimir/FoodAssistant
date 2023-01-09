//
//  StubIngredientManager.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class StubIngredientManager: ShopListCalculatable {
    func getShopList(ingredients: [FoodAssistant.IngredientProtocol], complection: @escaping ([FoodAssistant.IngredientViewModel]) -> Void) {
        
    }
}
