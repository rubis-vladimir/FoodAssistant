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
    private let instruction: Instruction
    
    init(instruction: Instruction) {
        self.instruction = instruction
    }
}

// MARK: - TVCellBuilderProtocol
extension InstructionCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(InstructionCell.self)
    }
    
    func cellHeight() -> CGFloat { UITableView.automaticDimension }
    
    func cellCount() -> Int { instruction.steps.count }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(InstructionCell.self,
                                                 indexPath: indexPath)
        let step = instruction.steps[indexPath.row]
        cell.configure(with: step)
        return cell
    }
}
