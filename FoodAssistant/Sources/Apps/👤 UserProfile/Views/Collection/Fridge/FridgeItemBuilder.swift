//
//  FridgeItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 10.12.2022.
//

import UIKit

/// #Строитель ячеек секции Fridge
final class FridgeItemBuilder {
    private let height: CGFloat = 55
    private let models: [IngredientViewModel]
    
    weak var delegate: UserProfilePresentation?
    
    init(models: [IngredientViewModel],
         delegate: UserProfilePresentation?) {
        self.models = models
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
        CGSize(width: collectionView.bounds.width,
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

