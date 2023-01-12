//
//  FilterManagerTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 12.01.2023.
//

import XCTest
@testable import FoodAssistant

class FilterManagerTests: XCTestCase {

    var sut: FilterManager!
    
    override func setUp() {
        super.setUp()
        sut = FilterManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testOverWrite() {
        //arange
        let parameter: FilterParameters = .excludeIngredients
        let value: [String] = ["Orange Baz", "Banana Bar"]
        
        //act
        sut.overWrite(parameter: parameter,
                      value: value)
        let parameters = sut.getRecipeParameters()
        
        //assert
        XCTAssertEqual("Under 5 min",
                       parameters[.time]?[0])
        XCTAssertEqual("Banana Bar",
                       parameters[.excludeIngredients]?[1])
    }
}
