//
//  StorageManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 06.12.2022.
//

import CoreData

/// #Менеджер сохранения и загрузки данных из БД
class StorageManager {

    static let shared = StorageManager()

    // MARK: - Core Data stack
    ///   Обращаемся к своему NSPersistentContainer который является оберткой для NSPersistentStoreCoordinator
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FoodAssistant")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private let viewContext: NSManagedObjectContext

    private init() {
        /// Обращаемся к NSManagedObjectContext через наш PersistentContainer
        viewContext = persistentContainer.viewContext
    }
}

// MARK: - Core Data Saving support
extension StorageManager {
    /// Сохранение контекста если он изменился
    private func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                print("Error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    /// Получение моделей типа `T` из БД
    /// - Parameters:
    ///  - model: тип модели
    ///  - predicate: логическое условие для фильтрации
    /// - Returns: массив моделей
    private func read<T: NSManagedObject>(model: T.Type, predicate: NSPredicate?) -> [T] {
        /// создаем запрос к базе данных "fetchRequest" - выбрать из базы объекты
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(T.self)")

        if let predicate = predicate {
            /// Добавляем предикат
            fetchRequest.predicate = predicate
        }

        do {
            /// Persistent Store Coordinator возвращает в context массив Managed Object
            let objects = try viewContext.fetch(fetchRequest) as! [T]
            /// при удаче возвращаем массив рецептов
            return objects
        } catch {
            let nserror = error as NSError
            print("Error \(nserror), \(nserror.userInfo)")
            /// при неудаче возвращаем пустой массив
            return []
        }
    }
}

// MARK: - DBRecipeManagement
extension StorageManager: DBRecipeManagement {

    func fetchRecipes(for target: TargetOfSave,
                      completion: @escaping ([RecipeProtocol]) -> Void) {
        let predicate = NSPredicate(format: "\(target.rawValue) == %@",
                                    NSNumber(value: true))
        let objects = read(model: CDRecipe.self, predicate: predicate)
        completion(objects)
    }

    func save(recipe: RecipeProtocol,
              for target: TargetOfSave) {
        let predicate = NSPredicate(format: "cdId == %@",
                                    NSNumber(value: recipe.id))
        if let object = read(model: CDRecipe.self, predicate: predicate).first {
            object.setValue(true, forKey: "\(target.rawValue)")
        } else {
            createCDRecipe(recipe: recipe, for: target)
        }
        saveContext()
    }

    func remove(id: Int,
                for target: TargetOfSave) {
        let predicate = NSPredicate(format: "cdId == %@",
                                    NSNumber(value: id))
        guard let object = read(model: CDRecipe.self, predicate: predicate).first else { return }

        switch target {
        case .isFavorite:
            if object.inBasket {
                object.setValue(false, forKey: target.rawValue)
            } else {
                viewContext.delete(object)
            }

        case .inBasket:
            if object.isFavorite {
                object.setValue(false, forKey: target.rawValue)
            } else {
                viewContext.delete(object)
            }
        }
        saveContext()
    }

    func fetchFavoriteId(completion: @escaping ([Int]) -> Void) {
        let predicate = NSPredicate(format: "isFavorite == %@",
                                    NSNumber(value: true))
        let objects = read(model: CDRecipe.self, predicate: predicate)
        let arrayId = objects.map { $0.id }
        completion(arrayId)
    }

    func check(id: Int) -> Bool {
        guard read(model: CDRecipe.self,
                   predicate: nil).first(where: {$0.id == id && $0.isFavorite == true }) != nil else { return false }
        return true
    }

    /// #Вспомогательный приватные функции
    /// Создает и добавляет в контекст модель данных CDRecipe
    ///  - Parameters:
    ///   - recipe: переданная модель рецепта
    ///   - target: цель сохранения рецепта
    private func createCDRecipe(recipe: RecipeProtocol,
                                for target: TargetOfSave) {
        /// Создаем модель рецепта CDRecipe и конфигурируем ее свойства
        let cdRecipe = CDRecipe(context: viewContext)
        cdRecipe.cdId = Int32(recipe.id)
        cdRecipe.title = recipe.title
        cdRecipe.imageName = recipe.imageName
        cdRecipe.cookingTime = recipe.cookingTime
        cdRecipe.cdServings = Int16(recipe.servings)
        
        switch target {
        case .isFavorite:
            cdRecipe.isFavorite = true
            cdRecipe.inBasket = false
        case .inBasket:
            cdRecipe.isFavorite = false
            cdRecipe.inBasket = true
        }
        
        /// Создаем модели CDIngredient и добавляем их в рецепт
        if let ingredients = recipe.ingredients {
            ingredients.forEach {
                let cdIngredient = CDIngredient(context: viewContext)
                cdIngredient.cdId = Int32($0.id)
                cdIngredient.name = $0.name
                cdIngredient.amount = $0.amount
                cdIngredient.unit = $0.unit
                cdIngredient.image = $0.image
                cdIngredient.recipe = cdRecipe
                cdRecipe.addToCdIngredients(cdIngredient)
            }
        }
        
        /// Создаем модели CDNutrient и добавляем их в рецепт
        if let nutrients = recipe.nutrients {
            nutrients.forEach {
                let cdNutrient = CDNutrient(context: viewContext)
                cdNutrient.name = $0.name
                cdNutrient.amount = $0.amount
                cdNutrient.unit = $0.unit
                cdRecipe.addToCdNutrients(cdNutrient)
            }
        }
        
        /// Создаем модели CDInstrutionStep и добавляем их в рецепт
        if let instructionSteps = recipe.instructions {
            instructionSteps.forEach {
                let cdInstructionStep = CDInstrutionStep(context: viewContext)
                cdInstructionStep.cdNumber = Int16($0.number)
                cdInstructionStep.step = $0.step
                cdRecipe.addToCdInstructionSteps(cdInstructionStep)
            }
        }
    }
}

// MARK: - DBIngredientsFridgeManagement
extension StorageManager: DBIngredientsManagement {
    func fetchIngredients(toUse: Bool, completion: @escaping ([IngredientProtocol]) -> Void) {
        let predicate1 = NSPredicate(format: "inFridge == %@",
                                    NSNumber(value: true))
        let predicate2 = NSPredicate(format: "toUse == %@",
                                    NSNumber(value: true))
        let predicate = toUse ?
        NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        : predicate1
        
        let objects = read(model: CDIngredient.self, predicate: predicate)
        completion(objects)
    }
    
    func save(ingredients: [IngredientProtocol]) {
        
        ingredients.forEach {
            let predicate1 = NSPredicate(format: "cdId == %@",
                                         NSNumber(value: $0.id))
            let predicate2 = NSPredicate(format: "inFridge == %@",
                                        NSNumber(value: true))
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            
            /// Обновляем количество если ингредиент уже добавлен
            if let object = read(model: CDIngredient.self,
                                 predicate: predicate).first {
                let amount = object.amount + $0.amount
                object.setValue($0.toUse, forKey: "toUse")
                object.setValue(amount, forKey: "amount")
                
            } else {
                /// Создаем и добавляем новый ингредиент
                createCDIngredient(ingredient: $0)
            }
        }
        saveContext()
    }
    
    func removeIngredient(id: Int) {
        let predicate1 = NSPredicate(format: "cdId == %@",
                                    NSNumber(value: id))
        let predicate2 = NSPredicate(format: "inFridge == %@",
                                    NSNumber(value: true))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2] )
        guard let object = read(model: CDIngredient.self, predicate: predicate).first else { return }
        viewContext.delete(object)
        saveContext()
    }
    
    func updateIngredient(id: Int, toUse: Bool) {
        let predicate1 = NSPredicate(format: "cdId == %@",
                                    NSNumber(value: id))
        let predicate2 = NSPredicate(format: "inFridge == %@",
                                    NSNumber(value: true))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2] )
        guard let object = read(model: CDIngredient.self, predicate: predicate).first else { return }
        
        object.setValue(toUse, forKey: "toUse")
        saveContext()
    }
    
    /// Создает модель CDIngredient для ингредиентов в холодильнике
    private func createCDIngredient(ingredient: IngredientProtocol) {
        let cdIngredient = CDIngredient(context: viewContext)
        cdIngredient.cdId = Int32(ingredient.id)
        cdIngredient.name = ingredient.name
        cdIngredient.image = ingredient.image
        cdIngredient.amount = ingredient.amount
        cdIngredient.unit = ingredient.unit
        cdIngredient.toUse = ingredient.toUse
        cdIngredient.inFridge = true
    }
}
