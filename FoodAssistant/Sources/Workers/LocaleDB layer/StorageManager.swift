//
//  StorageManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 06.12.2022.
//

import CoreData

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
    
    
    // MARK: - Public Methods - Методы по управлению данными
    /// Загрузка транзакций из даты
    func fetchData() -> [Recipe] {
        /// создаем запрос к базе данных "fetchRequest" - выбрать из базы ВСЕ объекты с типом Transact
        let fetchRequest: NSFetchRequest<New> = FoodAssistant.fetchRequest()
        do {
            ///Persistent Store Coordinator возвращает в context массив Managed Object `[Transact]`
            let transactions = try viewContext.fetch(fetchRequest)
            /// при удаче возвращаем массив транзакций
            return transactions
        } catch let error {
            print (error)
            /// при неудаче возвращаем пустой массив
            return []
        }
    }
    
    /// Сохраняем транзакции в памяти
    func saveData(newTransaction: CDRecipe, completion: (CDRecipe) -> Void) {
        /// Создаем экземпляр ManageObject  `Transact`
        /// из нашего контекста `viewContext` чтобы  присвоить ему значение`newTransaction`
        var transaction = Transact(context: viewContext)
        transaction = newTransaction
        completion(transaction)
        saveContext()
        print("---------- сохранили транзакцию \(newTransaction.descr ?? "")")
    }
    
    ///    Собрать новую транзакцию из элементов/свойств и вернуть собраный объект для дальнейшего использования
    func createTransact(cost: Double, description: String, category: String,
                        date: Date, note: String, income: Bool) -> Transact {
        /// Создаем транзакцию и присваиваем ей значения
        let transaction = New(context: viewContext)
        transaction.cost = cost
        transaction.descr = description
        transaction.category = category
        transaction.date = date
        transaction.note = note
        transaction.incomeTransaction = income
        print("----------Собрали и сохранили новую транзакцию")
        /// Сохраняем в контексте
        saveContext()
        return transaction
    }
    
    /// Редактируем транзакцию
    func editData(editingTransaction: Transact, from newTransaction: Transact) {
        print("----------Отредактировал транзакцию \(editingTransaction.descr ?? "") [удалили её]")
        /// удаляем старую транзакцию в контексте
        deleteTransaction(editingTransaction)
        /// сохраняем новую транзакцию в контексте
        saveData(newTransaction: editingTransaction)  { transaction in }
        /// сохраняем контекст
        saveContext()
        print("---------- на транзакцию \(newTransaction.descr ?? "")")
    }
    
    func deleteTransaction(_ transaction: Transact) {
        viewContext.delete(transaction)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    /// Сохранение контекста если он изменился
    func saveContext () {
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

