//
//  RecipeListInteractorTests.swift
//  FoodAssistantTests
//
//  Created by Владимир Рубис on 06.01.2023.
//

import XCTest
@testable import FoodAssistant

public enum TestCase {
    case success, failure
}

final class RecipeListInteractorTests: XCTestCase {
    
    var dataFetcher: StubDataFetcher!
    var imageDownloader: StubImageDownloader!
    var translateService: StubTranslateService!
    var storage: SpyStorageManager!
    var sut: RecipeListInteractor!
    
    override func setUp() {
        super.setUp()
        imageDownloader = StubImageDownloader()
    }
    
    override func tearDown() {
        dataFetcher = nil
        imageDownloader = nil
        translateService = nil
        storage = nil
        sut = nil
        super.tearDown()
    }
    
    /// Конфигурация для успешных и неуспешных кейсов
    func assembly(caseDF: TestCase,
                  caseTS: TestCase) {
        
        let mockEnRecipes: [Recipe] = [Recipe(id: 5678,
                                              title: "Pizza Baz",
                                              readyInMinutes: 20,
                                              servings: 4),
                                       Recipe(id: 1234,
                                              title: "Borsch Bar",
                                              readyInMinutes: 60,
                                              servings: 3)]
        let mockRuRecipes: [Recipe] = [Recipe(id: 5678,
                                              title: "Пицца Баз",
                                              readyInMinutes: 20,
                                              servings: 4),
                                       Recipe(id: 1234,
                                              title: "Борщ Бар",
                                              readyInMinutes: 60,
                                              servings: 3)]
        
        storage = SpyStorageManager(arrayId: [5678])
        
        switch caseDF {
        case .success:
            dataFetcher = StubDataFetcher(error: nil,
                                          models: mockEnRecipes)
        case .failure:
            dataFetcher = StubDataFetcher(error: .dataLoadingError,
                                          models: [])
        }
        
        switch caseTS {
        case .success:
            translateService = StubTranslateService(ruRecipe: mockRuRecipes,
                                                    target: "ru")
        case .failure:
            translateService = StubTranslateService(error: .translateError)
        }
        
        sut = RecipeListInteractor(dataFetcher: dataFetcher,
                                   imageDownloader: imageDownloader,
                                   translateService: translateService,
                                   storage: storage)
    }
    
    func currentAppleLanguage() -> String {
        let appleLanguageKey = "AppleLanguages"
        let userdef = UserDefaults.standard
        var currentWithoutLocale = "Base"
        if let langArray = userdef.object(forKey: appleLanguageKey) as? [String] {
            if var current = langArray.first {
                if let range = current.range(of: "-") {
                    current = String(current[..<range.lowerBound])
                }
                
                currentWithoutLocale = current
            }
        }
        return currentWithoutLocale
    }
    
    
    func testFetchRecommendedDFFailure() {
        //arange
        assembly(caseDF: .failure,
                 caseTS: .success)
        
        //act
        sut.fetchRecommended(number: 5) { result in
            switch result {
            case .success:
                //assert
                XCTFail()
                
            case .failure(let error):
                //assert
                XCTAssertEqual(DataFetcherError.dataLoadingError, error)
            }
        }
    }
    
    func testFetchRecommendedDFSuccessTSFailore() {
        //arange
        assembly(caseDF: .success,
                 caseTS: .failure)
        
        //act
        sut.fetchRecommended(number: 5) { result in
            switch result {
            case .success(let recipes): /// Непереведенные рецепты
                let recipeCount = recipes.count
                let recipeName = recipes.first?.title
                
                //assert
                XCTAssertEqual(2, recipeCount)
                XCTAssertEqual("Pizza Baz", recipeName)
                
            case .failure(let error):
                //assert
                XCTAssertEqual(DataFetcherError.translateError, error)
            }
        }
    }
    
    func testFetchRecommendedDFSuccessTSSuccess() {
        //arange
        assembly(caseDF: .success,
                 caseTS: .success)
        
        //act
        sut.fetchRecommended(number: 5) { [weak self] result in
            switch result {
            case .success(let recipes): /// Переведенные рецепты
                let recipeCount = recipes.count
                let recipeFirst = recipes.first
                
                //assert
                XCTAssertEqual(2, recipeCount)
                
                if self?.currentAppleLanguage() == "ru" {
                    XCTAssertEqual("Пицца Баз", recipeFirst?.title)
                }
                
            case .failure:
                //assert
                XCTFail()
            }
        }
    }
    
    func testSaveRecipe() {
        //arange
        assembly(caseDF: .success,
                 caseTS: .success)
        
        //act
        sut.fetchRecommended(number: 5) { _ in } /// Загружаем рецепты
        sut.saveRecipe(id: 1234,
                       for: .isFavorite) /// Сохраняем в избранное
        sut.updateFavoriteId() /// Обновляем список изранных Id
        let check = sut.checkFavorite(id: 1234) /// Чек флага
        var count = storage.arrayIds.count
        print(storage.arrayIds)
        
        //assert
        XCTAssertEqual(true, check)
        XCTAssertEqual(2, count)
        
        //act
        sut.removeRecipe(id: 5678)
        count = storage.arrayIds.count
        //assert
        XCTAssertEqual(1, count)
    }
}
