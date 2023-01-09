//
//  TVFactoryProtocol.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

// MARK: - Фабрика для TableView
/// #Протокол фабрики для TableView
protocol TVCFactoryProtocol {
    /// Строители ячеек
    var builders: [TVSectionProtocol] { get }
}

/// #Протокол секции таблицы
protocol TVSectionProtocol {
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
}
