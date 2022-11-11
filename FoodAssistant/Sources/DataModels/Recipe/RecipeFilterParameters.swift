//
//  FilterParameters.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.11.2022.
//

import Foundation

struct RecipeFilterParameters {
    /// Вид кухни ????
    var cuisine: String?
    /// Диета
    var diet: String?
    /// Тип рецепта
    var type: String?
    /// Включая ингредиенты
    var includeIngredients: [String]
    /// Исключая ингредиенты
    var excludeIngredients: [String]
    /// Непереносимости
    var intolerances: [String]
    /// Максимальное количество каллорий в рецепте
    var maxCalories: Int?
    /// Сортировка
    var sort: String?
    
    init(cuisine: String?, diet: String?, type: String?, intolerances: [String], includeIngredients: [String], excludeIngredients: [String], maxCalories: Int?, sort: String?) {
        self.cuisine = cuisine
        self.diet = diet
        self.type = type
        self.intolerances = intolerances
        self.includeIngredients = includeIngredients
        self.excludeIngredients = excludeIngredients
        self.maxCalories = maxCalories
        self.sort = sort
    }
    
    init() {
        cuisine = nil
        diet = nil
        type = nil
        intolerances = []
        includeIngredients = []
        excludeIngredients = []
        maxCalories = nil
        sort = nil
    }
}

/* type recipe
 основное блюдо
 гарнир
 Десерт
 закуска
 салат
 Хлеб
 Завтрак
 Суп
 Напиток
 соус
 маринад
 еда для пальцев
 закуска
 Напиток
 
 main course
 side dish
 dessert
 appetizer
 salad
 bread
 breakfast
 soup
 beverage
 sauce
 marinade
 fingerfood
 snack
 drink
 */

/* Вид кухни
 African
 American
 British
 Cajun
 Caribbean
 Chinese
 Eastern European
 European
 French
 German
 Greek
 Indian
 Irish
 Italian
 Japanese
 Jewish
 Korean
 Latin American
 Mediterranean
 Mexican
 Middle Eastern
 Nordic
 Southern
 Spanish
 Thai
 Vietnamese
 */

/* Непереносимости
 Молочные продукты
 Яйцо
 Глютен
 Зерно
 Арахис
 Морепродукты
 Кунжут
 Моллюски
 Соя
 Сульфит
 Деревянный орех
 Пшеница
 
 
 */

/*
 maxReadyTime    Номер    20    Максимальное время в минутах должно потребоваться для приготовления и приготовления рецепта.
 */

/*
 Recipe Sorting Options
 This is a list of possible values for the sort parameter of the complex recipe search endpoint.

 (empty)
 meta-score
 popularity
 healthiness
 price
 time
 random
 max-used-ingredients
 min-missing-ingredients
 alcohol
 caffeine
 copper
 energy
 calories
 calcium
 carbohydrates
 carbs
 choline
 cholesterol
 total-fat
 fluoride
 trans-fat
 saturated-fat
 mono-unsaturated-fat
 poly-unsaturated-fat
 fiber
 folate
 folic-acid
 iodine
 iron
 magnesium
 manganese
 vitamin-b3
 niacin
 vitamin-b5
 pantothenic-acid
 phosphorus
 potassium
 protein
 vitamin-b2
 riboflavin
 selenium
 sodium
 vitamin-b1
 thiamin
 vitamin-a
 vitamin-b6
 vitamin-b12
 vitamin-c
 vitamin-d
 vitamin-e
 vitamin-k
 sugar
 zinc
 */


/*
 
 includeIngredients    строка    помидоры, сыр    Разделенный запятыми список ингредиентов, которые должны/должны использоваться в рецептах.
 excludeIngredients    строка    Яйца    Разделенный запятыми список ингредиентов или типов ингредиентов, которые рецепты не должны содержать.
 */
