//
//  RecipeFilterPresenterTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 12.01.2023.
//

import XCTest
@testable import FoodAssistant

final class RecipeFilterPresenterTests: XCTestCase {

    var view: SpyRecipeFilterView!
    var router: SpyRecipeFilterRouter!
    var interactor: SpyRecipeFilterInteractor!
    var rootPresenter: SpyRecipeFilterRootPresenter!
    var sut: RecipeFilterPresenter!
    
    override func setUp() {
        super.setUp()
        
        assembly()
    }
    
    override func tearDown() {
        view = nil
        router = nil
        interactor = nil
        sut = nil
        super.tearDown()
    }
    
    func assembly() {
        var recipeParameters = RecipeFilterParameters()
        recipeParameters.time = 30
        let parameters: [FilterParameters : [TagModel]] = [
            .time: [TagModel(title: "Under 30 Baz", isSelected: false)],
            .dishType: [TagModel(title: "Salad Foo", isSelected: false)]
        ]
        let array: [IndexPath] = [IndexPath(row: 0, section: 0),
                                  IndexPath(row: 1, section: 1)]
        let text = "Bar Baz"
        
        view = SpyRecipeFilterView()
        router = SpyRecipeFilterRouter()
        interactor = SpyRecipeFilterInteractor(recipeParameters: recipeParameters,
                                               parameters: parameters,
                                               arrayIndexPath: array,
                                               text: text)
        rootPresenter = SpyRecipeFilterRootPresenter()
        sut = RecipeFilterPresenter(interactor: interactor,
                                    router: router)
        sut.view = view
        sut.rootPresenter = rootPresenter
    }
    
    func testDidTapElementCell() {
        //arange
        let indexPath = IndexPath(row: 0, section: 1)
        
        //act
        sut.didTapElementCell(true,
                              indexPath: indexPath) // 1
        let count = interactor.arrayIndexPath.count
        let check = sut.checkFlag(indexPath: indexPath) // 2
        
        //assert
        XCTAssertEqual(3, count)
        XCTAssertEqual(true, check)
    }
    
    func testDidTapFilterButton() {
        //act
        sut.didTapFilterButton()
        let count = router.count
        
        //assert
        XCTAssertEqual(1, count)
    }
    
    func testDidTapChange() {
        //act
        sut.didTapChange(parameter: .time,
                         text: "")
        let count = interactor.parameters.count
        let updateCount = view.updateCount
        
        //assert
        XCTAssertEqual(1, count)
        XCTAssertEqual(1, updateCount)
    }
    
    func testChangeSelectedIngredients() {
        //act
        sut.changeSelectedIngredients(section: 0) // 1
        let text = view.text
        sut.update(section: 0) // 2
        let updateCount = view.updateCount
        
        //assert
        XCTAssertEqual("Bar Baz", text)
        XCTAssertEqual(1, updateCount)
    }
    
    func testDidTapShowResultButton() {
        //act
        sut.changeSelectedIngredients(section: 0) // 1
        sut.didTapShowResultButton() // 2
        let text = rootPresenter.text
        let parameter = rootPresenter.parameters?.time
        let count = router.count
        
        //assert
        XCTAssertEqual("Bar Baz", text)
        XCTAssertEqual(30, parameter)
        XCTAssertEqual(1, count)
    }
    
    func testGetStartData() {
        //arange
        let text = "Test Foo"
        
        //act
        sut.getStartData(text: text)
        let textView = view.text
        let updateCount = view.updateCount
        
        //assert
        XCTAssertEqual(textView, text)
        XCTAssertEqual(1, updateCount)
    }
}
