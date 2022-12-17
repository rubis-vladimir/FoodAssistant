//
//  IngredientCalculator.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 17.12.2022.
//

import Foundation

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
        
        let availableIngredients = storage.fetchIngredients { availableIngredients in
            
        }
        return []
    }
    
    func combineRelevant(ingredients: [IngredientProtocol]) -> [IngredientProtocol] {
        
        var dict: [Int: IngredientProtocol] = [:]
        
        for ingredient in ingredients {
            if var value = dict[ingredient.id] {
                value.amount = value.amount + ingredient.amount
                dict[ingredient.id] = value
            } else {
                dict[ingredient.id] = ingredient
            }
        }
        
        return dict.map{ $0.value }
    }
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
