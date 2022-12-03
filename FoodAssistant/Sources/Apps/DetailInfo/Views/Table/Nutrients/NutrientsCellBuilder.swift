//
//  NutrientsCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Строитель ячейки NutrientsCell
final class NutrientsCellBuilder {
    /// Высота ячейки
    private let height = CGFloat(100)
    private let nutrition: Nutrition
    
    init(nutrition: Nutrition) {
        self.nutrition = nutrition
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
        return NutrientsCell(nutrition: nutrition)
    }
}
