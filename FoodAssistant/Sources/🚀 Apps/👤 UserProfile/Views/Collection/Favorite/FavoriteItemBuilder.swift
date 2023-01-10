//
//  FavoriteItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import UIKit

/// #Строитель ячеек секции Favorite
final class FavoriteItemBuilder {
    
    private let models: [RecipeViewModel]
    
    weak var delegate: UserProfilePresentation?
    
    init(models: [RecipeViewModel],
         delegate: UserProfilePresentation?) {
        self.models = models
        self.delegate = delegate
    }
    
    /// Рассчитывает размер ячеек
    private func calculateItemSize(width: CGFloat) -> CGSize {
        let padding: CGFloat = AppConstants.padding
        let itemPerRow: CGFloat = 1
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (width - paddingWidht) / itemPerRow
        let availableHeight: CGFloat = 125
        
        return CGSize(width: availableWidth,
                      height: availableHeight)
    }
}

// MARK: - CVItemBuilderProtocol
extension FavoriteItemBuilder: CVSelectableItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(ThirdRecipeCell.self)
        collectionView.register(SecondRecipeCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        calculateItemSize(width: collectionView.bounds.width)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        
        /// Получаем модель для ячейки
        let model = models[indexPath.item]
        
        /// Создаем и настраиваем ячейку
        let cell = collectionView.dequeueReusableCell(SecondRecipeCell.self,
                                                      indexPath: indexPath)
        cell.deleteDelegate = delegate
        cell.basketDelegate = delegate
        cell.configure(with: model, type: .delete)
        
        if let imageName = model.imageName {
            /// Загрузка изображения
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
        let model = models[indexPath.item]
        delegate?.didSelectItem(id: model.id)
    }
}
