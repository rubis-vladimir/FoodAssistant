//
//  BasketInteractorTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import XCTest
@testable import FoodAssistant

final class BasketInteractorTests: XCTestCase {

    var ingredientManager: StubIngredientManager!
    var imageDownloader: StubImageDownloader!
    var storage: SpyStorageManager!
    var presenter: SpyBasketPresenter!
    var sut: BasketInteractor!

    override func setUp() {
        super.setUp()
        assembly()
    }

    override func tearDown() {
        ingredientManager = nil
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

        ingredientManager = StubIngredientManager()
        imageDownloader = StubImageDownloader(error: .dataLoadingError)
        storage = SpyStorageManager(arrayRecipes: mockArrayRecipes,
                                    arrayId: [1234])
        presenter = SpyBasketPresenter()
        sut = BasketInteractor(imageDownloader: imageDownloader,
                               storage: storage,
                               ingredientManager: ingredientManager)
        sut.presenter = presenter
    }

    func getModels() {
        sut.fetchRecipeFromBasket { _ in }
        sut.fetchIngredients { _ in }
    }

    func testAddIngredientsInFridge() {
        // arange
        getModels()

        // act
        sut.changeIsCheck(id: 357, flag: true)
        sut.changeIsCheck(id: 124, flag: false)
        let count = presenter.count

        // assert
        XCTAssertEqual(1, count)

        // act
        sut.addIngredientsInFridge()
        let save = storage.arrayIds.last

        // assert
        XCTAssertEqual(357, save)
    }

    func testRemoveRecipe() {
        // arange
        let id = 1234
        getModels()

        // act
        sut.removeRecipe(id: id)
        let count = storage.arrayIds.count

        // assert
        XCTAssertEqual(0, count)
    }

    func testFetchImage() {
        // act
        sut.fetchImage("",
                       type: .recipe) { result in
            // assert
            switch result {
            case .success:
                XCTFail("Must be error")
            case .failure(let error):
                XCTAssertEqual(DataFetcherError.dataLoadingError, error)
            }
        }
    }
}
