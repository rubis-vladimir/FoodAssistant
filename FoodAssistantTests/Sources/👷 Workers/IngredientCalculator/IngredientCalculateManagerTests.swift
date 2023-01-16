//
//  IngredientCalculatorTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 12.01.2023.
//

import XCTest
@testable import FoodAssistant

final class IngredientCalculateManagerTests: XCTestCase {

    var sut: IngredientCalculateManager!
    var storage: SpyStorageManager!

    let mockIngredientsInFridge: [IngredientProtocol] = [
        Ingredient(id: 357,
                   name: "orange",
                   dtoAmount: 4,
                   dtoUnit: ""),
        Ingredient(id: 246,
                   name: "sausage",
                   dtoAmount: 500,
                   dtoUnit: "g"),
        Ingredient(id: 111,
                   name: "salt",
                   dtoAmount: 1,
                   dtoUnit: "bag"),
        Ingredient(id: 120,
                   name: "cheese",
                   dtoAmount: 100,
                   dtoUnit: "g")
    ]

    override func setUp() {
        super.setUp()
        storage = SpyStorageManager(arrayIngredients: mockIngredientsInFridge)
        sut = IngredientCalculateManager(storage: storage)
    }

    override func tearDown() {
        sut = nil
        storage = nil
        super.tearDown()
    }

    func testGetShopList() {
        // arange
        let mockRecipeIngredients: [IngredientProtocol] = [
            Ingredient(id: 357,
                       name: "orange",
                       dtoAmount: 1,
                       dtoUnit: ""),
            Ingredient(id: 246,
                       name: "sausage",
                       dtoAmount: 300,
                       dtoUnit: "g"),
            Ingredient(id: 220,
                       name: "cheese",
                       dtoAmount: 200,
                       dtoUnit: "g"),
            Ingredient(id: 357,
                       name: "oranges",
                       dtoAmount: 5,
                       dtoUnit: ""),
            Ingredient(id: 111,
                       name: "salt",
                       dtoAmount: 1.3,
                       dtoUnit: "tbsp")
        ]

        // act
        sut.getShopList(ingredients: mockRecipeIngredients) { ingredients in
            // assert
            XCTAssertEqual(2, ingredients.count)
            XCTAssertEqual("orange", ingredients[1].name)
            XCTAssertEqual(2, ingredients[1].amount)
            XCTAssertEqual(100, ingredients[0].amount)
        }

        // act
        sut.getShopList(ingredients: mockIngredientsInFridge) { ingredients in
            // assert
            XCTAssertEqual([], ingredients)
        }
    }
}
