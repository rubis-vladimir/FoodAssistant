//
//  UPTabSetCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

/// Строитель ячейки UserProfileCell
final class UPTabSetCellBuilder {
    /// Высота ячейки
    private let height = CGFloat(50)
    /// Делегат для обработки нажатия на кнопку
    private weak var delegate: UserProfilePresentation?
    
    init(delegate: UserProfilePresentation? = nil) {
        self.delegate = delegate
    }
}

// MARK: - TVCBuilderProtocol
extension UPTabSetCellBuilder: TVCBuilderProtocol {
    
    func cellHeight() -> CGFloat { height }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UPTabSetCell.self,
                                                 indexPath: indexPath)
        cell.delegate = delegate
        return cell
    }
}


