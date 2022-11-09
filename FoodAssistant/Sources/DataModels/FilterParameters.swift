//
//  FilterParameters.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

struct FilterParameters {
    var cuisine: String?
    var diet: String?
    var type: String?
    var intolerances: [String]
    var maxCalories: Int?
    var sort: String?
    
    init(cuisine: String?, diet: String?, type: String?, intolerances: [String], maxCalories: Int?, sort: String?) {
        self.cuisine = cuisine
        self.diet = diet
        self.type = type
        self.intolerances = intolerances
        self.maxCalories = maxCalories
        self.sort = sort
    }
    
    init() {
        cuisine = nil
        diet = nil
        type = nil
        intolerances = []
        maxCalories = nil
        sort = nil
    }
}
