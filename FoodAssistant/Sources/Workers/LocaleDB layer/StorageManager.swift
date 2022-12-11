//
//  StorageManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 06.12.2022.
//

import CoreData

enum TargetOfSave {
    case favorite
    case basket
}

protocol DBRecipeManagement {
    
    func fetchRecipes(completion: @escaping ([RecipeProtocol]) -> Void)
    
    func save(recipe: RecipeProtocol, for goal: TargetOfSave)
    func remove(id: Int, for goal: TargetOfSave)
//    func deleteRecipe(id: Int)
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
    
    func fetchRecipes(completion: @escaping ([RecipeProtocol]) -> Void) {
        let objects = read(model: CDRecipe.self)
        completion(objects)
    }
    
    func read<T: NSManagedObject>(model: T.Type) -> [T] {
        /// создаем запрос к базе данных "fetchRequest" - выбрать из базы ВСЕ объекты с типом CDRecipe
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(T.self)")
        do {
            ///Persistent Store Coordinator возвращает в context массив Managed Object `[CDRecipe]`
            let objects = try viewContext.fetch(fetchRequest) as! [T]
            /// при удаче возвращаем массив рецептов
            return objects
        } catch let error {
            print (error)
            /// при неудаче возвращаем пустой массив
            return []
        }
    }
    
    func save(recipe: RecipeProtocol, for goal: TargetOfSave) {
        
        switch goal {
            
        case .favorite:
            if let object = read(model: CDRecipe.self).first(where: {$0.id == recipe.id}) {
                object.setValue(true, forKey: "isFavorite")
            } else {
                createCDRecipe(recipe: recipe, for: goal)
            }
        case .basket:
            if let object = read(model: CDRecipe.self).first(where: {$0.id == recipe.id}) {
                object.setValue(true, forKey: "inBasket")
            } else {
                createCDRecipe(recipe: recipe, for: goal)
            }
        }
        
        saveContext()
//        let objects = read(model: CDRecipe.self)
//
//        guard !objects.contains(where: {$0.id == recipe.id}) else { return }
//        createCDRecipe(recipe: recipe)
//        saveContext()
    }
    
    func remove(id: Int, for goal: TargetOfSave) {
        
        guard var object = read(model: CDRecipe.self).first(where: {$0.id == id}) else { return }
        
        switch goal {
        case .favorite:
            if object.inBasket {
                object.setValue(false, forKey: "isFavorite")
                saveContext()
            } else {
                delete(object: object)
            }
            
        case .basket:
            if object.isFavorite {
                object.setValue(false, forKey: "inBasket")
                saveContext()
            } else {
                delete(object: object)
            }
        }
    }
    
    func update(recipe: CDRecipe) {
        
    }
    
    private func createCDRecipe(recipe: RecipeProtocol, for goal: TargetOfSave) {
        let cdRecipe = CDRecipe(context: viewContext)
        cdRecipe.cdId = Int32(recipe.id)
        cdRecipe.title = recipe.title
        cdRecipe.imageName = recipe.imageName
        cdRecipe.cookingTime = recipe.cookingTime
        cdRecipe.cdServings = Int16(recipe.servings)
        
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
        
        if let nutrients = recipe.nutrients {
            nutrients.forEach {
                let cdNutrient = CDNutrient(context: viewContext)
                cdNutrient.name = $0.name
                cdNutrient.amount = $0.amount
                cdNutrient.unit = $0.unit
                cdRecipe.addToCdNutrients(cdNutrient)
            }
        }
        
        if let instructionSteps = recipe.instructions {
            instructionSteps.forEach {
                let cdInstructionStep = CDInstrutionStep(context: viewContext)
                cdInstructionStep.cdNumber = Int16($0.number)
                cdInstructionStep.step = $0.step
                cdRecipe.addToCdInstructionSteps(cdInstructionStep)
            }
        }
    }
    
    func delete<T: NSManagedObject>(object: T) {
        viewContext.delete(object)
        saveContext()
    }
    
//    func deleteRecipe(id: Int) {
//        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
//
//        do {
//            /// Пробуем получить объект с соответствующим идентификатором
//            let object = try viewContext.fetch(fetchRequest).first(where: {$0.id == id })
//            /// Удаляем найденный объект
//            guard let deleteObject = object else { return }
//            viewContext.delete(deleteObject)
//
//            /// Перезаписываем контекст
//            try viewContext.save()
//        } catch let error {
//            print (error)
//        }
//    }
    
//    private func convert(cdRecipe: CDRecipe) -> RecipeViewModel {
//
//
//        return recipe
//    }
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

