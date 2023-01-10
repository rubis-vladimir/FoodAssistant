//
//  AddedRecipesItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Строитель ячеек секции AddedRecipes
final class AddedRecipesItemBuilder {
    
    private let recipes: [RecipeViewModel]
    
    weak var delegate: BasketPresentation?
    
    init(recipes: [RecipeViewModel],
         delegate: BasketPresentation?) {
        self.recipes = recipes
        self.delegate = delegate
    }
}

// MARK: - RecommendedItemBuilder
extension AddedRecipesItemBuilder: CVSelectableItemBuilderProtocol {
    
    func register(collectionView: UICollectionView) {
        collectionView.register(FirstRecipeCell.self)
    }
    
    func itemCount() -> Int { recipes.count }
    
    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        CGSize(width: collectionView.bounds.height - 50,
               height: collectionView.bounds.height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FirstRecipeCell.self,
                                                      indexPath: indexPath)
        let recipe = recipes[indexPath.item]
        cell.deleteDelegate = delegate
        cell.configure(with: recipe, type: .delete)
        
        if let imageName = recipe.imageName {
            delegate?.fetchImage(imageName,
                                 type: .recipe) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(data: imageData)
                }
            }
        }
        return cell
    }
    
    func didSelectItem(indexPath: IndexPath) {
        let id = recipes[indexPath.row].id
        delegate?.didSelectItem(id: id)
    }
}
