//
//  NutrientsCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

// Строитель ячейки NutrientsCell
final class NutrientsCellBuilder {
    /// Высота ячейки
    private let height = CGFloat(100)
    private let nutrition: Nutrition
    
    var action: ((UITableViewCell) -> Void)?
    
    init(nutrition: Nutrition,
         action: ((UITableViewCell) -> Void)? = nil) {
        self.nutrition = nutrition
        self.action = action
    }
}

// MARK: - TVCellBuilderProtocol
extension NutrientsCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(NutrientsCell.self)
    }
    
    func cellHeight() -> CGFloat { height }
    
    func cellCount() -> Int { 1 }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NutrientsCell.self,
                                                 indexPath: indexPath)
        cell.configure(with: nutrition)
        return cell
    }
}
