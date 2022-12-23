//
//  IngredientCalculator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 17.12.2022.
//

import Foundation

/// #Протокол расчета ингредиентов для шоп-листа
protocol ShopListCalculatable {
    /// Получает ингредиенты для шоп-листа
    ///  - Parameters:
    ///   - ingredients:массив необходимых ингредиентов
    ///   - complection: захватывает массив вью-моделей для отображения в шоп листе
    func getShopList(ingredients: [IngredientProtocol],
                     complection: @escaping ([IngredientViewModel]) -> Void)
}

/// #Менеджер для рассчета ингредиентов
final class IngredientCalculateManager {
    
    private let storage: DBIngredientsManagement
    
    init(storage: DBIngredientsManagement) {
        self.storage = storage
    }
}

// MARK: - IngredientCalculatable
extension IngredientCalculateManager: ShopListCalculatable {
    
    func getShopList(ingredients: [IngredientProtocol],
                     complection: @escaping ([IngredientViewModel]) -> Void) {
        
        storage.fetchIngredients(toUse: true) { [weak self] available in
            
            guard let self = self else { return }
            let result = self.calculateIngredients(necessary: ingredients, available: available)
            complection(result)
        }
    }
    
    /// Объединяет одинаковые ингредиенты
    ///  - Parameter array:массив ингредиентов
    ///  - Returns: объединенный массив ингредиентов
    private func unitIngredients(_ array: [IngredientViewModel]) -> [IngredientViewModel] {
        
        var finalArray: [IngredientViewModel] = []
        /// Получаем все идентификаторы ингредиентов и которые дублируются
        let arrayId = array.map{$0.id}
        let arrayIdDuplicates = arrayId.duplicate()
        
        /// Для неповторяющихся ингредиентов - добавляем сразу в результирующий массив
        array.forEach {
            if !arrayIdDuplicates.contains($0.id) {
                finalArray.append($0)
            }
        }
        
        /// Для повторяющихся - сперва складываем количество
        arrayIdDuplicates.forEach { id in
            let dublicate = array.filter{ $0.id == id }
            let amount = dublicate.map { $0.amount }.reduce(0, +)
            let ingredient = IngredientViewModel(id: dublicate[0].id,
                                                 image: dublicate[0].image,
                                                 name: dublicate[0].name,
                                                 amount: amount,
                                                 unit: dublicate[0].unit)
            finalArray.append(ingredient)
        }
        return finalArray
    }
    
    
    /// Рассчитывает необходимые ингредиенты с учетом имеющихся
    ///  - Parameters:
    ///   - necessary:массив необходимых ингредиентов
    ///   - available: массив имеющихся ингредиентов
    ///  - Returns: результирующий массив вью моделей
    private func calculateIngredients(necessary: [IngredientProtocol],
                              available: [IngredientProtocol]) -> [IngredientViewModel] {
        
        /// Преобразуем массивы ингредиентов в массивы вью моделей
        let necessary = necessary.map { IngredientViewModel(ingredient: $0) }
        let available = available.map { IngredientViewModel(ingredient: $0) }
        /// Объединяем повторяющиеся необходимые ингредиенты
        let unitNessesary = unitIngredients(necessary)
        /// Создаем результирующий массив и добавляем в него ингредиенты с учетом имеющихся
        var ingredients: [IngredientViewModel] = []
        
        unitNessesary.forEach { ingredient in
            /// Количество
            var amount: Float = 0.0
            /// Ищем нужные ингредиенты
            let availableIngredients = available.filter({ $0 == ingredient })
            
            if !availableIngredients.isEmpty {
                /// Если нашли - в зависимости от единиц измерения указываем количество
                if IngredientUnit.contains(ingredient.unit){
                    /// для штук и граммов
                   
                    amount = ingredient.amount - availableIngredients.map{$0.amount}.reduce(0, +)
                } else if !IngredientVolume.contains(ingredient.unit) {
                    
                    /// для всего, кроме единиц объема
                    amount = ingredient.amount
                    availableIngredients.forEach {
                        if ingredient.unit == $0.unit {
                            amount -= $0.amount
                        }
                    }
                }
                print(ingredient)
            } else {
                /// Если не нашли
                amount = ingredient.amount
            }
            
            guard amount > 0 else { return }
            ingredients.append(
                IngredientViewModel(id: ingredient.id,
                                    image: ingredient.image,
                                    name: ingredient.name,
                                    amount: amount,
                                    unit: ingredient.unit)
            )
        }
        return ingredients
    }
}

/// #Рассчитываемые единицы измерения
enum IngredientUnit: String, CaseIterable {
    /// Грамм
    case g = "g"
    /// Штук
    case item = ""
}

extension IngredientUnit {
    static func contains(_ string: String) -> Bool {
        Self.allCases.map {$0.rawValue}.contains(string)
    }
}

/// #Объемные единицы измерения
enum IngredientVolume: String, CaseIterable {
    case ml = "ml"
    /// "tsp" "t"
    case tsp = "tsp"
    /// "tbsp" "T"
    case tbsp = "tbsp"
    /// "cup" "c"
    case cup = "cup"
}

extension IngredientVolume {
    static func contains(_ string: String) -> Bool {
        Self.allCases.map {$0.rawValue}.contains(string)
    }
}
