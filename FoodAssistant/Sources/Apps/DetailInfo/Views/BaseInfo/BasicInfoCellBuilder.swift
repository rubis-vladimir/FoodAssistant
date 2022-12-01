//
//  BasicInfoCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

// Строитель ячейки BaseInfoCell
final class BasicInfoCellBuilder {

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
extension BasicInfoCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(BasicInfoCell.self)
    }
    
    func cellHeight() -> CGFloat { UITableView.automaticDimension }
    
    func cellCount() -> Int { 1 }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BasicInfoCell.self,
                                                 indexPath: indexPath)
        cell.configure(with: model)
        
        
        if let urlString = model.image {
            let imageName = String(urlString.dropFirst(37))
            print(imageName)
            delegate?.fetchImage(with: imageName) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(with: imageData)
                }
            }
        }
        return cell
    }
}

