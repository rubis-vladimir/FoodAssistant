//
//  IngredientsCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

// Строитель ячейки IngredientsCell
final class IngredientsCellBuilder {
    /// Высота ячейки
    private let height = CGFloat(66)
    private let ingredients: [Ingredient]
    
    weak var delegate: DetailInfoPresentation?
    
    var action: ((UITableViewCell) -> Void)?
    
    init(ingredients: [Ingredient],
         action: ((UITableViewCell) -> Void)? = nil) {
        self.ingredients = ingredients
        self.action = action
    }
}

// MARK: - TVCellBuilderProtocol
extension IngredientsCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(IngredientsCell.self)
    }
    
    func cellHeight() -> CGFloat { height }
    
    func cellCount() -> Int { ingredients.count }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(IngredientsCell.self,
                                                 indexPath: indexPath)
        let ingredient = ingredients[indexPath.row]
        cell.configure(with: ingredient)
        
//        delegate?.fetchImage(with: ingredient.name, size: .mini) { imageData in
//            DispatchQueue.main.async {
//                cell.updateImage(with: imageData)
//            }
//        }
        return cell
    }
}
