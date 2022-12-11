//
//  BasicInfoCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Строитель ячейки BaseInfoCell
final class BasicInfoCellBuilder {

    private let model: RecipeProtocol
    weak var delegate: DetailInfoPresentation?
    
    init(model: RecipeProtocol,
         delegate: DetailInfoPresentation?) {
        self.model = model
        self.delegate = delegate
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
        
        
        if let imageName = model.imageName {
//            let imageName = String(urlString.dropFirst(37))
            
            delegate?.fetchRecipe(with: imageName) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(with: imageData)
                }
            }
        }
        return cell
    }
}

