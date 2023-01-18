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
final class DIFactory {
    // MARK: - Properties
    private let tableView: UITableView
    private let recipe: RecipeProtocol
    private let tvAdapter: TVAdapter?

    private weak var delegate: DetailInfoPresentation?

    // MARK: - Init
    ///  - Parameters:
    ///    - tableView: настраиваемая таблица
    ///    - delegate: делегат для передачи UIEvent (VC)
    ///    - scrollDelegate: делегат скролла таблицы
    ///    - recipe: модель рецепта
    init(tableView: UITableView,
         delegate: DetailInfoPresentation?,
         scrollDelegate: ScrollDelegate?,
         recipe: RecipeProtocol) {
        self.tableView = tableView
        self.delegate = delegate
        self.recipe = recipe

        /// Определяем адаптер для tableView
        tvAdapter = TVAdapter(
                              scrollDelegate: scrollDelegate)
        setupTableView()
    }

    // MARK: - Private func
    /// Настраивает табличное представление
    private func setupTableView() {
        tableView.dataSource = tvAdapter
        tableView.delegate = tvAdapter
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white

        tvAdapter?.configure(with: builders)
    }

    /// Создает строитель секции
    ///  - Parameters:
    ///     - type: тип секции
    ///  - Returns: объект протокола строителя секции
    private func createBuilder(type: DISectionType) -> TVSectionProtocol {
        switch type {

        case .baseInfo:
            let cellBuilder = BasicInfoCellBuilder(model: recipe,
                                                   delegate: delegate)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: nil,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder

        case .nutrients(let nutrients):
            let cellBuilder = NutrientsCellBuilder(nutrients: nutrients,
                                                   height: Constants.heightNutrition)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: Constants.titleNutrition,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder

        case .ingredients(let ingredients):

            let cellBuilder = IngredientsCellBuilder(ingredients: ingredients,
                                                     height: Constants.heightIngredients,
                                                     delegate: delegate)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: Constants.titleIngredients,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder

        case .instructions(let instructions):
            let cellBuilder = InstructionCellBuilder(instructions: instructions,
                                                     delegate: delegate)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: Constants.titleInstructions,
                                                  cellBuilder: cellBuilder)
            return sectionBuilder
        }
    }
}

// MARK: - TVFactoryProtocol
extension DIFactory: TVFactoryProtocol {

    var builders: [TVSectionProtocol] {
        var builders: [TVSectionProtocol] = []

        /// Добавляем секцию с основной информацией
        builders.append(createBuilder(type: .baseInfo))

        /// Добавляем секцию с питательными веществами
        if let nutrients = recipe.nutrients {
            builders.append(createBuilder(type: .nutrients(nutrients)))
        }

        /// Добавляем секцию с ингредиентами
        if let ingredients = recipe.ingredients, !ingredients.isEmpty {

            let viewModels = ingredients.map {
                var model = IngredientViewModel(ingredient: $0)
                model.isCheck = delegate?.checkFor(ingredient: model) ?? false
                return model
            }
            builders.append(createBuilder(type: .ingredients(viewModels)))
        }

        /// Добавляем секцию с инструкцией по приготовлению
        if let instructions = recipe.instructions, !instructions.isEmpty {
            builders.append(createBuilder(type: .instructions(instructions)))
        }

        return builders
    }
}

// MARK: - Constants
extension DIFactory {
    private struct Constants {
        static let titleNutrition = "Nutrients".localize()
        static let titleIngredients = "Ingredients".localize()
        static let titleInstructions = "Instructions".localize()

        static let heightNutrition: CGFloat = 100
        static let heightIngredients: CGFloat = 66
    }
}
