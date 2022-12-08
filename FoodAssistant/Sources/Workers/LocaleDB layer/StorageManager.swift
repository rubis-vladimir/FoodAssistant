//
//  StorageManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 06.12.2022.
//

import CoreData

protocol DBRecipeManagement {
    
    func fetchRecipes(completion: @escaping ([CDRecipe]) -> Void)
    
    func save(recipe: RecipeViewModel)
    
    func deleteRecipe(id: Int)
}


// MARK: Менеджер для сохранения и загрузки сохраненных рецептов
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
        /// viewContext - база данных восстановленная из памяти / контекст главной очереди
    }
}

// MARK: - DBRecipeManagement
extension StorageManager: DBRecipeManagement {
    
    func fetchRecipes(completion: @escaping ([CDRecipe]) -> Void) {
        
        /// создаем запрос к базе данных "fetchRequest" - выбрать из базы ВСЕ объекты с типом CDRecipe
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        do {
            ///Persistent Store Coordinator возвращает в context массив Managed Object `[CDRecipe]`
            let objects = try viewContext.fetch(fetchRequest)
            objects.first?.ingredients
            /// при удаче возвращаем массив рецептов
            completion(objects)
        } catch let error {
            print (error)
            /// при неудаче возвращаем пустой массив
            completion([])
        }
    }
    
    func save(recipe: RecipeViewModel) {
        let cdRecipe = CDRecipe(context: viewContext)
        cdRecipe.id = Int32(recipe.id)
        cdRecipe.title = recipe.title
        cdRecipe.imageName = recipe.imageName
        cdRecipe.cookingTime = recipe.cookingTime
        cdRecipe.servings = Int16(recipe.servings)
        
        if let ingredients = recipe.ingredients {
            let cdIngredients = ingredients.map {
                let cdIngredient = CDIngredient(context: viewContext)
                cdIngredient.id = Int32($0.id)
                cdIngredient.name = $0.name
                cdIngredient.amount = $0.amount
                cdIngredient.unit = $0.unit
                cdIngredient.image = $0.image
                cdIngredient.recipe = cdRecipe
                return cdIngredient
            }
            cdRecipe.ingredients?.addingObjects(from: cdIngredients)
        }
        
        if let nutrients = recipe.nutrients {
            let cdNutrients = nutrients.map {
                let cdNutrient = CDNutrient(context: viewContext)
                cdNutrient.name = $0.name
                cdNutrient.amount = $0.amount
                cdNutrient.unit = $0.unit
                return cdNutrient
            }
            cdRecipe.nutrients?.addingObjects(from: cdNutrients)
        }
        
        if let instructionSteps = recipe.instructionSteps {
            let cdInstructionSteps = instructionSteps.map {
                let cdInstructionStep = CDInstrutionStep(context: viewContext)
                cdInstructionStep.number = Int16($0.number)
                cdInstructionStep.step = $0.step
                return cdInstructionStep
            }
            cdRecipe.instructionSteps?.addingObjects(from: cdInstructionSteps)
        }
        saveContext()
    }
    
    func deleteRecipe(id: Int) {
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        
        do {
            /// Пробуем получить объект с соответствующим идентификатором
            let object = try viewContext.fetch(fetchRequest).first(where: {$0.id == id })
            /// Удаляем найденный объект
            guard let deleteObject = object else { return }
            viewContext.delete(deleteObject)
            
            /// Перезаписываем контекст
            try viewContext.save()
        } catch let error {
            print (error)
        }
    }
    
    private func convert(cdRecipe: CDRecipe) -> RecipeViewModel {
        
        var recipe = RecipeViewModel(id: Int(cdRecipe.id),
                                     title: cdRecipe.title ?? "",
                                     cookingTime: cdRecipe.cookingTime ?? "",
                                     servings: Int(cdRecipe.servings),
                                     imageName: cdRecipe.imageName)
        
        if let cdIngredients = cdRecipe.ingredients?.allObjects as? [CDIngredient] {
            let ingredients = cdIngredients.map {
                Ingredient(id: Int($0.id),
                           image: $0.image,
                           name: $0.name ?? "",
                           amount: $0.amount,
                           unit: $0.unit)
            }
            recipe.ingredients = ingredients
        }
        
        if let cdNutrients = cdRecipe.nutrients?.allObjects as? [CDNutrient] {
            let nutrients = cdNutrients.map {
                Nutrient(name: $0.name ?? "",
                         amount: $0.amount,
                         unit: $0.unit ?? "")
            }
            recipe.nutrients = nutrients
        }
        
        if let cdInstructionSteps = cdRecipe.instructionSteps?.allObjects as? [CDInstrutionStep] {
            let instructionSteps = cdInstructionSteps.map {
                InstuctionStep(number: Int($0.number),
                               step: $0.step ?? "")
            }.sorted { $0.number > $1.number }
            recipe.instructionSteps = instructionSteps
        }
        return recipe
    }
}



extension StorageManager{
    
    // MARK: - Core Data Saving support
    /// Сохранение контекста если он изменился
    private func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

