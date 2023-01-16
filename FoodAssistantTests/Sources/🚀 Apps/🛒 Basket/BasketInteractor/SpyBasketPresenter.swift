//
//  SpyBasketPresenter.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import Foundation
@testable import FoodAssistant

class SpyBasketPresenter: BasketBusinessLogicDelegate {

    var count: Int = 0

    func handOver(ingredients: [IngredientViewModel]) {
        count += 1
    }
}
