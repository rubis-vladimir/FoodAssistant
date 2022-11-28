//
//  BaseInfoCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

// Строитель ячейки BaseInfoCell
final class BaseInfoCellBuilder {
    /// Высота ячейки
    private let height = CGFloat(500)
    private let model: Recipe
    
    var action: ((UITableViewCell) -> Void)?
    
    init(model: Recipe,
         action: ((UITableViewCell) -> Void)? = nil) {
        self.model = model
        self.action = action
    }
}

// MARK: - TVCellBuilderProtocol
extension BaseInfoCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(BaseInfoCell.self)
    }
    
    func cellHeight() -> CGFloat { height }
    
    func cellCount() -> Int { 1 }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BaseInfoCell.self,
                                                 indexPath: indexPath)
        cell.configure(with: model)
        return cell
    }
}

