//
//  AddedRecipesItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Строитель ячеек секции Recommended
final class AddedRecipesItemBuilder {
    
    private let height: CGFloat = 320
    private let models: [RecipeViewModel]
    
    weak var delegate: BasketPresentation?
    
    init(models: [RecipeViewModel],
         delegate: BasketPresentation?) {
        self.models = models
        self.delegate = delegate
    }
}

// MARK: - RecommendedItemBuilder
extension AddedRecipesItemBuilder: CVItemBuilderProtocol {
    func register(collectionView: UICollectionView) {
        collectionView.register(FirstRecipeCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(collectionView: UICollectionView) -> CGSize {
        CGSize(width: collectionView.bounds.height - 50,
               height: collectionView.bounds.height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FirstRecipeCell.self,
                                                      indexPath: indexPath)
        let model = models[indexPath.item]
        cell.delegate = delegate
        cell.configure(with: model)
        
        if let imageName = model.imageName {
            delegate?.fetchRecipeImage(with: imageName) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(data: imageData)
                }
            }
        }
        return cell
    }
}
