//
//  RecipeFilterInteractor.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import Foundation

/// #Протокол делегата бизнес-логики
protocol RecipeFilterBusinessLogicDelegate: AnyObject {
    /// Обновить секцию
    /// - Parameter section: номер секции
    func update(section: Int)
}

/// #Слой бизнес логики модуля RecipeFilter
final class RecipeFilterInteractor {
    
    weak var presenter: RecipeFilterBusinessLogicDelegate?
    
    private var dict: [FilterParameters : [TagModel]] = [:]
    
    private let filterManager: FilterManagement
    
    init(filterManager: FilterManagement) {
        self.filterManager = filterManager
    }
    
    /// Получение названий ингредиентов из строки (разделенный запятой)
    /// - Parameter str: строка
    /// - Returns: массив названий ингредиентов
    private func ingredients(from str: String) -> [String] {
        return str.components(separatedBy: ", ")
            .flatMap { $0.split(separator: ",") }
            .map(String.init)
    }
    
    /// Получение значений из строки
    /// - Parameter str: строка
    /// - Returns: массив значений
    private func values(from str: String) -> [String] {
        let separators = CharacterSet(charactersIn: ",; ")
        return str.components(separatedBy: separators).filter{ $0 != "" }
    }
    
    /// Определяет количество из строки
    /// - Parameters:
    ///  - str: строка
    ///  - inOrder: порядок
    /// - Returns: количество
    private func number(fromString str: String?,
                        inOrder: Int) -> Int? {
        guard let str = str else { return nil }
        switch inOrder {
        case 1:
            return values(from: str).compactMap(Int.init).last
            
        default:
            let array = values(from: str).compactMap(Int.init)
            return array.count == 2 ? array.first : 0
        }
    }
    
    /// Получить выбранные данные для параметра
    private func getSelected(_ parameter: FilterParameters) -> [String] {
        dict[parameter]?.filter { $0.isSelected == true }.map { $0.title } ?? []
    }
}

// MARK: - RecipeFilterBusinessLogic
extension RecipeFilterInteractor: RecipeFilterBusinessLogic {
    
    func getParameters(completion: @escaping (RecipeFilterParameters) -> Void) {
        let selectedTime = getSelected(.time).first
        let selectedСalories = getSelected(.calories).first
        let selectedCuisines = getSelected(.region)
        let selectedDiet = getSelected(.diet).first
        let selectedType = getSelected(.dishType)
        let selectedIncludeIngredients = getSelected(.includeIngredients)
        let selectedExcludeIngredients = getSelected(.excludeIngredients)
        
        let filterParameters = RecipeFilterParameters(
            time: number(fromString: selectedTime, inOrder: 0),
            cuisine: selectedCuisines,
            diet: selectedDiet,
            type: selectedType,
            intolerances: [],
            includeIngredients: selectedIncludeIngredients,
            excludeIngredients: selectedExcludeIngredients,
            minCalories: number(fromString: selectedСalories, inOrder: 0),
            maxCalories: number(fromString: selectedСalories, inOrder: 1),
            sort: nil
        )
        completion(filterParameters)
    }
    
    func fetchFilterParameters(completion: @escaping ([FilterParameters : [TagModel]]) -> Void) {
        var dict = [FilterParameters : [TagModel]]()
        
        filterManager.getRecipeParameters().forEach {
            let tagModel = $0.value.map { TagModel(title: $0, isSelected: false)  }
            dict[$0.key] = tagModel
        }
        
        self.dict = dict
        completion(dict)
    }
    
    func fetchText(with parameter: FilterParameters,
                   completion: @escaping (String) -> Void) {
        guard let models = dict[parameter] else {
            completion("")
            return
        }
        
        let titles = models.map{ $0.title }
        let text = titles.joined(separator: ", ")
        completion(text)
    }
    
    func update(parameter: FilterParameters,
                text: String,
                completion: @escaping ([FilterParameters : [TagModel]]) -> Void) {
        let titles = ingredients(from: text)
        filterManager.overWrite(parameter: parameter,
                                value: titles)
        
        dict[parameter] = titles.map { TagModel(title: $0, isSelected: false) }
        completion(dict)
    }
    
    func checkFlag(indexPath: IndexPath) -> Bool {
        guard let parameter = FilterParameters.allCases.first(where: { $0.rawValue == indexPath.section }),
              let model = dict[parameter]?[indexPath.item] else { return false }
        return model.isSelected
    }
    
    func changeFlag(_ flag: Bool, indexPath: IndexPath) {
        guard let parameter = FilterParameters.allCases.first(where: { $0.rawValue == indexPath.section }) else { return }
        guard var models = dict[parameter] else { return }
        
        switch parameter {
        case .time, .calories, .diet:
            for i in 0..<models.count {
                models[i].isSelected = i == indexPath.item ? flag : false
            }
            dict[parameter] = models
            presenter?.update(section: indexPath.section)
        default:
            models[indexPath.item].isSelected = flag
            dict[parameter] = models
        }
    }
}
