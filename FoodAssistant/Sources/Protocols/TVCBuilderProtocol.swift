//
//  TVCBuilderProtocol.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

/// Протокол конструктора для создания и конфигурации ячейки
protocol TVCBuilderProtocol {
    /// Идентификатор ячейки
    var reuseId: String { get }
    /// Возвращает высоту ячейки
    func cellHeight() -> CGFloat
    /// Создает ячейку по indexPath
    func cellAt(indexPath: IndexPath,
                tableView: UITableView) -> UITableViewCell
}

