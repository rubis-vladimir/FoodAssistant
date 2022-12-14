//
//  IngredientsCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Строитель ячейки IngredientsCell
final class IngredientsCellBuilder {
    /// Высота ячейки
    private let height = CGFloat(66)
    private let ingredients: [IngredientProtocol]
    
    weak var delegate: DetailInfoPresentation?
    
    init(ingredients: [IngredientProtocol],
         delegate: DetailInfoPresentation?) {
        self.ingredients = ingredients
        self.delegate = delegate
    }
}

// MARK: - TVCellBuilderProtocol
extension IngredientsCellBuilder: TVCellBuilderProtocol {
    func register(tableView: UITableView) {
        tableView.register(IngredientCell.self)
    }
    
    func cellHeight() -> CGFloat { UITableView.automaticDimension }
    
    func cellCount() -> Int { ingredients.count }
    
    func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(IngredientCell.self,
                                                 indexPath: indexPath)
        let ingredient = ingredients[indexPath.row]
        cell.configure(with: ingredient)
        
        delegate?.fetchIngredients(with: ingredient.image ?? "", size: .mini) { imageData in
            DispatchQueue.main.async {
                cell.updateImage(with: imageData)
            }
        }
        return cell
    }
}
