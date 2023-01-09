//
//  RecipeListInteractorTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import XCTest
@testable import FoodAssistant

final class RecipeListInteractorTests: XCTestCase {

    var dataFetcher: StubDataFetcher!
    var imageDownloader: StubImageDownloader!
    var translateService: StubTranslateService!
    var storage: SpyStorageManager!
    var sut: RecipeListInteractor!
    
    
    override func setUp() {
        super.setUp()
        assembly()
    }
    
    override func tearDown() {
        dataFetcher = nil
        imageDownloader = nil
        storage = nil
        presenter = nil
        sut = nil
        super.tearDown()
    }
    
    func assembly() {
        let mockIngredients: [Ingredient] = [Ingredient(id: 357,
                                                        name: "Cheese Bar",
                                                        dtoAmount: 200),
                                             Ingredient(id: 246,
                                                        name: "Sausage Baz",
                                                        dtoAmount: 300)]
        
        let mockArrayRecipes: [RecipeProtocol] = [Recipe(id: 5678,
                                                         title: "Pizza Baz",
                                                         readyInMinutes: 20,
                                                         servings: 4,
                                                         extendedIngredients: mockIngredients),
                                                  Recipe(id: 1234,
                                                         title: "Borsch Foo",
                                                         readyInMinutes: 60,
                                                         servings: 3)]
        
        dataFetcher = StubIngredientManager()
        imageDownloader = StubImageDownloader(error: .dataLoadingError)
        storage = SpyStorageManager(arrayRecipes: mockArrayRecipes)
        presenter = SpyBasketPresenter()
        sut = BasketInteractor(imageDownloader: imageDownloader,
                               storage: storage,
                               ingredientManager: ingredientManager)
        sut.presenter = presenter
    }

    func testExample() {
        
    }

}
