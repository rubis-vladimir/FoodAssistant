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
        let indexPath: IndexPath = [4, 1]
        var calories: Int?
        
        //act
        sut.fetchFilterParameters { parameters in
            
            print(parameters)
        }
        sut.changeFlag(true, indexPath: indexPath)
        
        sut.getParameters { parameters in
            calories = parameters.maxCalories
            print(parameters)
        }
//        let caloriesMinOne = parameters?.minCalories
//        let caloriesMaxOne = parameters?.maxCalories
//
        //assert
        XCTAssertEqual(200, calories)
        
    }
    
    func testFetchFilterParameters() {
        //arange
        var calories: String?
        
        //act
        sut.fetchFilterParameters { parameters in
            calories = parameters[.calories]?.first?.title
        }
        
        //assert
        XCTAssertEqual("500 Foo", calories)
    }
    
    func testUpdateParameters() {
        //arange
        
        let text = "Meat Foo, Carrot Foo,Foo"
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
