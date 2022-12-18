//
//  IngredientCalculator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 17.12.2022.
//

import Foundation



enum IngredientUnit {
    case size(_ number: Float)
    case volume(_ number: Float)
    case weight(_ number: Float)
    case number(_ number: Float)
    /// "servings", "slices", "head"
}

enum IngredientWeight: String {
    /// Грамм
    case g = "gramm"
    /// Фунт
    case lb = "funt"
    /// Унция
    case ounce = "ounce"
}

extension IngredientWeight {
    var inGramm: Float {
        switch self {
        case .g: return 1.0
        case .lb: return 0.45359237
        case .ounce: return 28.3495
        }
    }
}

enum IngredientSize: String {
    /// Маленький
    case small = "small"
    /// Средний
    case medium = "medium"
    /// Большой
    case large = "large"
}

enum IngredientVolume: String {
    case ml = "mililiter"
    /// "tsp" "t"
    case tsp = "teaspoon"
    /// "tbsp" "T"
    case tbsp = "tablespoon"
    /// "cup" "c"
    case cup = "cup"
}

extension IngredientVolume {
    var inLiter: Float {
        switch self {
        case .ml: return 0.001
        case .tsp: return 0.004929
        case .tbsp: return 0.014787
        case .cup: return 0.236588
        }
    }
}


protocol IngredientCalculatable {
    func getShopList(ingredients: [IngredientProtocol]) -> [IngredientProtocol]
    
    func combineRelevant(ingredients: [IngredientProtocol]) -> [IngredientProtocol]
}


final class IngredientCalculator {
    
    private let storage: DBIngredientsFridgeManagement
    
    init(storage: DBIngredientsFridgeManagement) {
        self.storage = storage
    }
    
    
}


extension IngredientCalculator: IngredientCalculatable {
    func getShopList(ingredients: [IngredientProtocol]) -> [IngredientProtocol] {
        
//        let availableIngredients = storage.fetchIngredients { availableIngredients in
//            
//        }
        return []
    }
    
    
    
    func combineRelevant(ingredients: [IngredientProtocol]) -> [IngredientProtocol] {
        
        var dict: [Int: IngredientProtocol] = [:]
        
        for ingredient in ingredients {
//            if let unit = ingredient.unit {
//
//                if ["tbsps", "tablespoons", "tablespoon", "tbsp", "T"].contains(unit) {
//                    let number = ingredient.amount * IngredientVolume.tbsp.inLiter
//                } else if ["tsps", "teaspoons", "teaspoon", "tsp", "t"].contains(unit) {
//                    let number = ingredient.amount * IngredientVolume.tsp.inLiter
//                } else if ["cups", "cup", "c"].contains(unit) {
//                    let number = ingredient.amount * IngredientVolume.cup.inLiter
//                } else if ["gramms", "g"].contains(unit) {
//                    let number = ingredient.amount
//                } else if  {
//
//                }
//
//                dict[ingredient.id] = .volume(IngredientVolume.cup)
//            }


            
//            if var value = dict[ingredient.id] {
//                if value.unit == ingredient.unit {
//                    value.amount = value.amount + ingredient.amount
//                    dict[ingredient.id] = value
//                } else {
//                    
//                }
//            } else {
//                dict[ingredient.id] = ingredient
//            }
        }
        
        return dict.map{ $0.value }
    }
    
//    private func combineUnit(first: String, second: String) -> Bool {
//
//    }
}

//extension Array {
//    public func toDictionary<Key: Hashable, Element: Numeric>(with selectKey: (Element) -> Key) -> [Key:Element] {
//        var dict = [Key:Element]()
//        for element in self {
//            if let value = dict[selectKey(element)] {
//                dict[selectKey(element)] = value + 1
//            } else {
//                dict[selectKey(element)] = element
//            }
//        }
//        return dict
//    }
//}
