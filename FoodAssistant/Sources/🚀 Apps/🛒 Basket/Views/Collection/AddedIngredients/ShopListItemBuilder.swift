//
//  ShopListItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.12.2022.
//

import UIKit

/// #Строитель ячеек секции RecommendedRecipe
final class ShopListItemBuilder {
    /// Высота ячейки
    private let height: CGFloat
    /// Вью модели ингредиентов
    private let models: [IngredientViewModel]
    
    weak var delegate: BasketPresentation?
    
    init(models: [IngredientViewModel],
         height: CGFloat,
         delegate: BasketPresentation?) {
        self.models = models
        self.height = height
        self.delegate = delegate
    }
}

// MARK: - RecommendedRecipeItemBuilder
extension ShopListItemBuilder: CVItemBuilderProtocol {
    
    func register(collectionView: UICollectionView) {
        collectionView.register(CVIngredientCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        CGSize(width: AppConstants.calculateItemWidth(width: collectionView.bounds.width,
                                                      itemPerRow: 1,
                                                      padding: AppConstants.padding),
               height: height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CVIngredientCell.self,
                                                      indexPath: indexPath)
        let model = models[indexPath.item]
        let isCheck = delegate?.checkFlag(id: model.id) ?? false
        
        cell.checkDelegate = delegate
        cell.configure(with: model, flag: isCheck)
        
        if let imageName = model.image {
            delegate?.fetchImage(imageName, type: .ingredient) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(with: imageData)
                }
            }
        }
        return cell
    }
}
