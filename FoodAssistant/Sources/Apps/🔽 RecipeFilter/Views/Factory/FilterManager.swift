//
//  FilterManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 27.12.2022.
//

import UIKit

protocol FilterManagement {
    
    func getRecipeParameters() -> [RecipeFilterParameter: [String]]
    
    func overWrite(parameter: RecipeFilterParameter, value: [String])
}


final class FilterManager {
    
    private struct RecipeFilterTagTitles {
        static var time = ["Under 5 min", "Under 15 min", "Under 30 min"]
        static var dishType = ["Dessert", "Drink", "Salad", "Side Dish", "Snack", "Soup", "Main course"]
        static var regions = ["African", "American", "British", "Chinese", "European",
                              "French", "German", "Greek", "Italian", "Spanish", "Vietnamese"]
        static var diets = ["Ketogenic", "Vegetarian", "Vegan", "Pescetarian", "Paleo"]
        static var calories = ["Under 200 Cal", "200 - 400 Cal", "400 - 600 Cal", "600 - 800 Cal"]
        static var includeIngredients = ["Chicken", "Beef", "Pasta", "Tomato", "Cheese"]
        static var excludeIngredients = ["Onion", "Broccoli", "Egg", "Olives"]
    }
}

extension FilterManager: FilterManagement {
    
    func getRecipeParameters() -> [RecipeFilterParameter: [String]] {
        var dict = [RecipeFilterParameter: [String]]()
        dict[.time] = RecipeFilterTagTitles.time
        dict[.dishType] = RecipeFilterTagTitles.dishType
        dict[.region] = RecipeFilterTagTitles.regions
        dict[.diet] = RecipeFilterTagTitles.diets
        dict[.calories] = RecipeFilterTagTitles.calories
        
        let key1 = RecipeFilterParameter.includeIngredients.title
        if let titles = UserDefaults.standard.value(forKey: key1) {
            dict[.includeIngredients] = titles as? [String]
        } else {
            UserDefaults.standard.set(RecipeFilterTagTitles.includeIngredients, forKey: key1)
        }
        
        let key2 = RecipeFilterParameter.excludeIngredients.title
        if let titles = UserDefaults.standard.value(forKey: key2) {
            dict[.excludeIngredients] = titles as? [String]
        } else {
            UserDefaults.standard.set(RecipeFilterTagTitles.excludeIngredients, forKey: key2)
        }
        
        return dict
    }
    
    func overWrite(parameter: RecipeFilterParameter, value: [String]) {
        UserDefaults.standard.set(value, forKey: parameter.title)
    }
}
