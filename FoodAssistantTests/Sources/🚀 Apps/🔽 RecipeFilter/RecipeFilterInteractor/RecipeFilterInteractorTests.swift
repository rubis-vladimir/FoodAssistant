//
//  RecipeFilterInteractorTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import XCTest
@testable import FoodAssistant

final class RecipeFilterInteractorTests: XCTestCase {
    
    var filterManager: SpyFilterManager!
    var presenter: SpyRecipeFilterPresenter!
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
        filterManager = SpyFilterManager(parameters: mockParameters)
        presenter = SpyRecipeFilterPresenter()
        sut = RecipeFilterInteractor(filterManager: filterManager)
        sut.presenter = presenter
    }

    func testGetParameters() {
        //arange
        guard let indexSecton = FilterParameters.allCases.first(where: { $0 == .calories })?.rawValue else {
            XCTFail()
            return
        }
        let indexPath = IndexPath(row: 1, section: indexSecton)
        var calories: Int?
        
        //act
        sut.fetchFilterParameters { _ in } /// Загрузка параметров
        
        sut.changeFlag(true, indexPath: indexPath) /// Изменяем флаг параметра
        ///
        sut.getParameters { parameters in
            calories = parameters.maxCalories
        } /// получаем параметры для запроса в сеть
        
        let check = sut.checkFlag(indexPath: indexPath) /// Чек флага
        let updateCount = presenter.updateCount /// Количество обновлений секций
        
        //assert
        XCTAssertEqual(200, calories)
        XCTAssertEqual(true, check)
        XCTAssertEqual(1, updateCount)
    }
    
    func testFetchFilterParameters() {
        //arange
        var calories: String?
        var count: Int?
        
        //act
        sut.fetchFilterParameters { parameters in
            calories = parameters[.calories]?.first?.title
            count = parameters[.excludeIngredients]?.count
        }
        
        //assert
        XCTAssertEqual("500 Foo", calories)
        XCTAssertEqual(2, count)
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
        let count = filterManager.parameters.count
        
        //assert
        XCTAssertEqual("Carrot Foo", ingredient)
        XCTAssertEqual(3, count)
    }
}
