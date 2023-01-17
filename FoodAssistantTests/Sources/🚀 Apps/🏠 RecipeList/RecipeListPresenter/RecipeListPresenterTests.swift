//
//  RecipeListPresenterTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 05.01.2023.
//

import XCTest
@testable import FoodAssistant

final class RecipeListPresenterTests: XCTestCase {

    var view: SpyRecipeListView!
    var router: SpyRecipeListRouter!
    var interactor: SpyRecipeListInteractor!
    var sut: RecipeListPresenter!

    let mockArrayRecipes: [RecipeProtocol] = [Recipe(id: 5678,
                                                     title: "Pizza Baz",
                                                     readyInMinutes: 20,
                                                     servings: 4),
                                              Recipe(id: 1234,
                                                     title: "Borsch Foo",
                                                     readyInMinutes: 60,
                                                     servings: 3)]

    override func setUp() {
        super.setUp()
        view = SpyRecipeListView(text: "Введенный текст")
        router = SpyRecipeListRouter()
    }

    override func tearDown() {
        view = nil
        router = nil
        interactor = nil
        sut = nil
        super.tearDown()
    }

    /// Конфигурация для успешных и неуспешных кейсов
    func assembly(testCase: TestCase) {
        switch testCase {
        case .success:
            interactor = SpyRecipeListInteractor(recipeModels: mockArrayRecipes, arrayId: [1234])
        case .failure:
            interactor = SpyRecipeListInteractor(error: .dataLoadingError)
        }

        sut = RecipeListPresenter(interactor: interactor,
                                  router: router)
        sut.view = view
    }

    func testRoute() {
        // arange
        assembly(testCase: .success)
        let recipeId = 1234

        // act
        sut.didTapFilterButton(searchText: "")
        sut.didSelectItem(id: recipeId)
        let id = router.id
        let count = router.count

        // assert
        XCTAssertEqual(recipeId, id)
        XCTAssertEqual(2, count)
    }

    func testDidTapFavoriteButton() {
        // arange
        assembly(testCase: .success)
        let testId = 1234

        // act
        var check = sut.checkFavorite(id: testId)
        // assert
        XCTAssertEqual(true, check)

        // act
        sut.didTapFavoriteButton(false, id: testId)
        check = sut.checkFavorite(id: testId)
        // assert
        XCTAssertEqual(false, check)
    }

    func testDidTapAddInBasketButton() {
        // arange
        assembly(testCase: .success)
        let testId = 2222

        // act
        sut.didTapAddInBasketButton(id: testId)
        let id = interactor.arrayIds.last

        // assert
        XCTAssertEqual(testId, id)
    }

    func testGetStartDataSuccess() {

        // arange
        assembly(testCase: .success)

        // act
        sut.getStartData()
        sut.didTapChangeLayoutButton(section: 0)
        let countUpdate = view.countUpdate

        // assert
        XCTAssertEqual(2, countUpdate)
    }

    func testGetStartDataFailure() {
        // arange
        assembly(testCase: .failure)

        // act
        sut.getStartData()
        let error = view.error?.error as? DataFetcherError
        let optionsCount = view.error?.recoveryOptions.count

        // assert
        XCTAssertEqual(DataFetcherError.dataLoadingError, error)
        XCTAssertEqual(2, optionsCount)
    }
}
