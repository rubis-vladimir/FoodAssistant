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
    
    weak var delegate: DetailInfoPresentation?
    
    var action: ((UITableViewCell) -> Void)?
    
    init(model: Recipe,
         delegate: DetailInfoPresentation?,
         action: ((UITableViewCell) -> Void)? = nil) {
        self.model = model
        self.delegate = delegate
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
        let imageName = String(model.id)
        print(imageName)
        
        delegate?.fetchImage(with: imageName, size: .huge) { imageData in
            DispatchQueue.main.async {
                cell.updateImage(with: imageData)
            }
        }
        return cell
    }
}

