//
//  FavoriteItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import UIKit

/// #Строитель ячеек секции Favorite
final class FavoriteItemBuilder {
    /// Высота ячеек
    private let height: CGFloat
    /// Вью модели рецептов
    private let models: [RecipeViewModel]

    weak var delegate: UserProfilePresentation?

    init(models: [RecipeViewModel],
         height: CGFloat,
         delegate: UserProfilePresentation?) {
        self.models = models
        self.height = height
        self.delegate = delegate
    }
}

// MARK: - CVItemBuilderProtocol
extension FavoriteItemBuilder: CVSelectableItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(SecondRecipeCell.self)
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
