//
//  InstructionCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

// Строитель ячейки IngredientsCell
final class InstructionCellBuilder {
    /// Высота ячейки
    private let height = CGFloat(150)
    private let instruction: Instruction
    
    var action: ((UITableViewCell) -> Void)?
    
    init(instruction: Instruction,
         action: ((UITableViewCell) -> Void)? = nil) {
        self.instruction = instruction
        self.action = action
    }
}

// MARK: - TVCellBuilderProtocol
extension InstructionCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(InstructionCell.self)
    }
    
    func cellHeight() -> CGFloat { height }
    
    func cellCount() -> Int { instruction.steps.count }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(InstructionCell.self,
                                                 indexPath: indexPath)
        let step = instruction.steps[indexPath.row]
        cell.configure(with: step)
        
        return cell
    }
}