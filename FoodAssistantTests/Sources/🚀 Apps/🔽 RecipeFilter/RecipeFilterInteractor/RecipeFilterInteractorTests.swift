//
//  RecipeFilterInteractorTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import XCTest
@testable import FoodAssistant

final class RecipeFilterInteractorTests: XCTestCase {
    
    var filterManager: StubFilterManager!
    var presenter: StubRecipeFilterPresenter!
    var sut: RecipeFilterInteractor!
    
    let mockParameters: [FilterParameters : [String]] = [.calories: ["500 Foo", "100 - 200 Baz"],
                                                         .excludeIngredients: ["Fish Bar", "Onion Baz"]]
    
    override func setUp() {
        super.setUp()
        assembly()
    }
    
    override  func tearDown() {
        filterManager = nil
        presenter = nil
        sut = nil
        super.tearDown()
    }
    
    func assembly() {
        filterManager = StubFilterManager(parameters: mockParameters)
        presenter = StubRecipeFilterPresenter()
        sut = RecipeFilterInteractor(filterManager: filterManager)
        sut.presenter = presenter
    }

    func testGetParameters() {
        //arange
        
        
        //act
        var parameters: RecipeFilterParameters?
        sut.getParameters { newParameters in
            parameters = newParameters
        }
        let caloriesMinOne = parameters?.minCalories
        let caloriesMaxOne = parameters?.maxCalories
        
        
        //assert
//        XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
        
    }
    
    func testOverwriteParameters() {
        
    }
    
    func testUpdateParameters() {
        //arange
        
        let text = "Meat Foo, Carrot Foo; Foo"
        var ingredient: String?
        
        //act
        sut.update(parameter: .includeIngredients,
                   text: text) { dict in
            ingredient = dict[.includeIngredients]?[1].title
        }
        
        //assert
        XCTAssertEqual("Carrot Foo", ingredient)
        
    }
}
