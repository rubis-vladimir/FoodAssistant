//
//  DIFactory.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// Типы текстовых ячеек модуля AddEvent
enum DISectionType {
    /// Секция с основной информацией
    case baseInfo
    /// Секция с питательными веществами
    case nutrients(_ nutrition: Nutrition)
    /// Секция с ингредиентами
    case ingredients(_ ingredients: [Ingredient])
    /// Секция с инструкциями по приготовлению
    case instructions(_ instructions: [Instruction])
}

/// Фабрика настройки табличного представления модуля AddEvent
final class DIFactory: NSObject {
    
    private let tableView: UITableView
    private weak var delegate: DetailInfoPresentation?
    private let model: Recipe
    
    private let tvAdapter: TVAdapter?
    
    /// Инициализатор
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    init(tableView: UITableView,
         delegate: DetailInfoPresentation?,
         model: Recipe) {
        
        self.tableView = tableView
        self.delegate = delegate
        self.model = model
        
        tvAdapter = TVAdapter(tableView: tableView)
    }
    
    /// Настраивает табличное представление
    func setupTableView() {
        tableView.dataSource = tvAdapter
        tableView.delegate = tvAdapter
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
//        let dummyViewHeight = CGFloat(40)
//        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
//        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        tvAdapter?.configure(with: builders)
    }
    
    /// Создает строитель секции
    ///  - Parameters:
    ///     - type: тип секции
    ///  - Returns: объект протокола строителя секции
    private func createBuilder(type: DISectionType) -> TVSectionBuilderProtocol {
        switch type {
            
        case .baseInfo:
            let cellBuilder = BaseInfoCellBuilder(model: model,
                                                  delegate: delegate)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: nil,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
            
        case .nutrients(let nutrition):
            let cellBuilder = NutrientsCellBuilder(nutrition: nutrition)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: HeaderConstants.titleNutrition,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
            
        case .ingredients(let ingredients):
            let cellBuilder = IngredientsCellBuilder(ingredients: ingredients)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: HeaderConstants.titleIngredients,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
            
        case .instructions(let instructions):
        
            print(instructions.count)
            
            let cellBuilder = InstructionCellBuilder(instruction: instructions[0])
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
        
        builders.append(createBuilder(type: .baseInfo))
        
        if let nutrition = model.nutrition {
            builders.append(createBuilder(type: .nutrients(nutrition)))
        }
        
        if let ingredients = model.extendedIngredients, !ingredients.isEmpty {
            builders.append(createBuilder(type: .ingredients(ingredients)))
        }
        
        if let instructions = model.analyzedInstructions, !instructions.isEmpty {
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


