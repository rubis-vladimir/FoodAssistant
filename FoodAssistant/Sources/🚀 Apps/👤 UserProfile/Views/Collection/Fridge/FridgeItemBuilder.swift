//
//  FridgeItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 10.12.2022.
//

import UIKit

/// #Строитель ячеек секции Fridge
final class FridgeItemBuilder {
    /// Высота ячеек
    private let height: CGFloat
    /// Вью модели ингредиентов
    private let models: [IngredientViewModel]
    
    weak var delegate: UserProfilePresentation?
    
    init(models: [IngredientViewModel],
         height: CGFloat,
         delegate: UserProfilePresentation?) {
        self.models = models
        self.height = height
        self.delegate = delegate
    }
}

// MARK: - CVItemBuilderProtocol
extension FridgeItemBuilder: CVItemBuilderProtocol {
    
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
        let flag = model.toUse
        
        cell.configure(with: model,
                       flag: flag)
        cell.checkDelegate = delegate
        cell.deleteDelegate = delegate
        
        if let imageName = model.image {
            delegate?.fetchImage(imageName,
                                 type: .ingredient) { imageData in
                DispatchQueue.main.async {
                    cell.updateImage(with: imageData)
                }
            }
        }
        return cell
    }
}

