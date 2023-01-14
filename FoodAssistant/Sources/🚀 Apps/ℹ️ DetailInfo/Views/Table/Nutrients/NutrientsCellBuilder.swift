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
    private let height: CGFloat
    /// Питательные вещества
    private let nutrients: [NutrientProtocol]
    
    init(nutrients: [NutrientProtocol],
         height: CGFloat) {
        self.nutrients = nutrients
        self.height = height
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
        return NutrientsCell(nutrients: nutrients)
    }
}
