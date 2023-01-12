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
    private let instructions: [InstructionStepProtocol]
    
    weak var delegate: TimerTapable?
    
    init(instructions: [InstructionStepProtocol],
         delegate: TimerTapable?) {
        self.instructions = instructions
        self.delegate = delegate
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
        cell.delegate = delegate
        return cell
    }
}
