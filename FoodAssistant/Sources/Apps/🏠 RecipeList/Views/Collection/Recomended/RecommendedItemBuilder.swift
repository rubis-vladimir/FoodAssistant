//
//  RecommendedItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Строитель ячеек секции Recommended
final class RecommendedItemBuilder {
    
    private let models: [RecipeViewModel]
    
    weak var delegate: RecipeListPresentation?
    
    init(models: [RecipeViewModel],
         delegate: RecipeListPresentation?) {
        self.models = models
        self.delegate = delegate
    }
}

// MARK: - CVItemBuilderProtocol
extension RecommendedItemBuilder: CVItemBuilderProtocol {
    func register(collectionView: UICollectionView) {
        collectionView.register(ThirdRecipeCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(collectionView: UICollectionView) -> CGSize {
        CGSize(width: collectionView.bounds.width * 0.6,
               height: collectionView.bounds.height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ThirdRecipeCell.self,
                                                      indexPath: indexPath)
        let model = models[indexPath.item]
        cell.delegate = delegate
        cell.configure(with: model, type: .favorite)
        
        if let imageName = model.imageName {
            delegate?.fetchImage(imageName, type: .recipe) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(data: imageData)
                }
            }
        }
        return cell
    }
    
    func didSelectItem(indexPath: IndexPath) {
        let id = models[indexPath.row].id
        delegate?.didSelectItem(id: id)
    }
}
