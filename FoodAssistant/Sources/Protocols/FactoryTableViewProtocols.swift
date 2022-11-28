//
//  TVFactoryProtocol.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

// MARK: - Фабрика для TableView
/// #Протокол фабрики для TableView
protocol TVFactoryProtocol {
    /// Строители ячеек
    var builders: [TVCBuilderProtocol] { get }
}

protocol TVCFactoryProtocol {
    /// Строители ячеек
    var builders: [TVSectionBuilderProtocol] { get }
}

/// #Протокол строителя секции таблицы
protocol TVSectionBuilderProtocol {
    /// Заголовок секции
    var titleHeader: String? { get }
    /// Строитель ячеек
    var cellBuilder: TVCellBuilderProtocol { get }
    /// Инициализатор
    init(titleHeader: String?, cellBuilder: TVCellBuilderProtocol)
}

/// #Протокол конструктора для создания и конфигурации ячейки
protocol TVCellBuilderProtocol {
    /// Регистрирует ячейку в таблице
    func register(tableView: UITableView)
    /// Возвращает высоту ячейки
    func cellHeight() -> CGFloat
    /// Возвращает количество ячеек
    func cellCount() -> Int
    /// Создает ячейку по indexPath
    func cellAt(indexPath: IndexPath,
                tableView: UITableView) -> UITableViewCell
    /// Действие при тапе на ячейку
    var action: ((UITableViewCell) -> Void)? { get }
}

/// Протокол конструктора для создания и конфигурации ячейки
protocol TVCBuilderProtocol {
    /// Возвращает высоту ячейки
    func cellHeight() -> CGFloat
    /// Создает ячейку по indexPath
    func cellAt(indexPath: IndexPath,
                tableView: UITableView) -> UITableViewCell
    
   
}
