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
    case nutrients
    /// Секция с ингредиентами
    case ingredients
    /// Секция с инструкциями по приготовлению
    case instructions
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
        
        tvAdapter?.configure(with: builders)
    }
    
    /// Создает строителя ячеек
    ///  - Parameters:
    ///     - model: модель данных
    ///     - type: тип ячейки
    ///   - Return: объект протокола строителя
    private func createBuilder(type: DISectionType) -> TVSectionBuilderProtocol {
        switch type {
        case .baseInfo:
            let cellBuilder = BaseInfoCellBuilder(model: model)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: nil, cellBuilder: cellBuilder)
            return sectionBuilder
        case .nutrients:
            let cellBuilder = BaseInfoCellBuilder(model: model)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: nil, cellBuilder: cellBuilder)
            return sectionBuilder
        case .ingredients:
            let cellBuilder = BaseInfoCellBuilder(model: model)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: nil, cellBuilder: cellBuilder)
            return sectionBuilder
        case .instructions:
            let cellBuilder = BaseInfoCellBuilder(model: model)
            cellBuilder.register(tableView: tableView)
            let sectionBuilder = TVSectionBuilder(titleHeader: nil, cellBuilder: cellBuilder)
            return sectionBuilder
        }
    }
}

//MARK: - TVFactoryProtocol
extension DIFactory: TVCFactoryProtocol {
    
    var builders: [TVSectionBuilderProtocol] {
        var builders: [TVSectionBuilderProtocol] = []
        
        builders.append(contentsOf: [createBuilder(type: .baseInfo)])
        
        return builders
    }
}



