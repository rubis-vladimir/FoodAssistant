//
//  DIFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Типы текстовых ячеек модуля AddEvent
enum DISectionType {
    /// Секция с основной информацией
    case baseInfo
    /// Секция с питательными веществами
    case nutrients(_ nutrients: [NutrientProtocol])
    /// Секция с ингредиентами
    case ingredients(_ ingredients: [IngredientViewModel])
    /// Секция с инструкциями по приготовлению
    case instructions(_ instructions: [InstructionStepProtocol])
}

/// #Фабрика для настройки представления коллекции модуля DetailInfo
final class DIFactory: NSObject {
    
    // MARK: - Properties
    private let tableView: UITableView
    private let model: RecipeProtocol
    private let tvAdapter: TVAdapter?
    
    private weak var delegate: DetailInfoPresentation?
    
    // MARK: - Init
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    ///    - model: модель рецепта
    init(tableView: UITableView,
         delegate: DetailInfoPresentation?,
         scrollDelegate: ScrollDelegate?,
         model: RecipeProtocol) {
        self.tableView = tableView
        self.delegate = delegate
        self.model = model
        
        /// Определяем адаптер для tableView
        tvAdapter = TVAdapter(tableView: tableView,
                              scrollDelegate: scrollDelegate)
    }
    
    // MARK: - Public func
    /// Настраивает табличное представление
    func setupTableView() {
        tableView.dataSource = tvAdapter
        tableView.delegate = tvAdapter
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        tvAdapter?.configure(with: builders)
    }
    
    // MARK: - Private func
    /// Создает строитель секции
    ///  - Parameters:
    ///     - type: тип секции
    ///  - Returns: объект протокола строителя секции
    private func createBuilder(type: DISectionType) -> TVSectionBuilderProtocol {
        switch type {
            
        case .baseInfo:
            let cellBuilder = BasicInfoCellBuilder(model: model,
                                                  delegate: delegate)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: nil,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
            
        case .nutrients(let nutrients):
            let cellBuilder = NutrientsCellBuilder(nutrients: nutrients)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: HeaderConstants.titleNutrition,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
            
        case .ingredients(let ingredients):
            
            let cellBuilder = IngredientsCellBuilder(ingredients: ingredients,
                                                     delegate: delegate)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: HeaderConstants.titleIngredients,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
            
        case .instructions(let instructions):
            let cellBuilder = InstructionCellBuilder(instructions: instructions)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: HeaderConstants.titleInstructions,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
        }
    }
}

// MARK: - TVFactoryProtocol
extension DIFactory: TVCFactoryProtocol {
    
    var builders: [TVSectionBuilderProtocol] {
        var builders: [TVSectionBuilderProtocol] = []
        
        /// Добавляем секцию с основной информацией
        builders.append(createBuilder(type: .baseInfo))
        
        /// Добавляем секцию с питательными веществами
        if let nutrients = model.nutrients {
            builders.append(createBuilder(type: .nutrients(nutrients)))
        }
        
        /// Добавляем секцию с ингредиентами
        if let ingredients = model.ingredients, !ingredients.isEmpty {
            let viewModels = ingredients.map {IngredientViewModel(ingredient: $0)}
            builders.append(createBuilder(type: .ingredients(viewModels)))
        }
        
        /// Добавляем секцию с инструкцией по приготовлению
        if let instructions = model.instructions, !instructions.isEmpty {
            builders.append(createBuilder(type: .instructions(instructions)))
        }
                            
        return builders
    }
}

// MARK: - Константы
extension DIFactory {
    private struct HeaderConstants {
        static let titleNutrition = "Питательные вещества"
        static let titleIngredients = "Ингредиенты"
        static let titleInstructions = "Инструкция по приготовлению"
    }
}


