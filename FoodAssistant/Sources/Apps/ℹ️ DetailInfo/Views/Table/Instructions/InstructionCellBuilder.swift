//
//  InstructionCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Строитель ячейки IngredientsCell
final class InstructionCellBuilder {
    /// Высота ячейки
    private let height: CGFloat = 150
    private let instructions: [InstructionStepProtocol]
    
    init(instructions: [InstructionStepProtocol]) {
        self.instructions = instructions
    }
}

// MARK: - TVCellBuilderProtocol
extension InstructionCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(InstructionCell.self)
    }
    
    func cellHeight() -> CGFloat { UITableView.automaticDimension }
    
    func cellCount() -> Int { instructions.count }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(InstructionCell.self,
                                                 indexPath: indexPath)
        let step = instructions[indexPath.row]
        cell.configure(with: step)
        return cell
    }
}
