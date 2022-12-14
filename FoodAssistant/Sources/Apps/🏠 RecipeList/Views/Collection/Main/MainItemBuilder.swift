//
//  MainItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Строитель ячеек секции Main
final class MainItemBuilder {
    
    private var layoutType: LayoutType = .split2xN
    private let models: [RecipeViewModel]
    
    weak var delegate: RecipeListPresentation?
    
    init(models: [RecipeViewModel],
         delegate: RecipeListPresentation?) {
        self.models = models
        self.delegate = delegate
        
        signInNotification()
    }
    
    /// Рассчитывает размеры ячейки
    private func calculateItemSize(width: CGFloat) -> CGSize {
        let padding: CGFloat = AppConstants.padding
        let itemPerRow: CGFloat = layoutType == .split1xN ? 1 : 2
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (width - paddingWidht) / itemPerRow
        let availableHeight = layoutType == .split1xN ? 125 : availableWidth + padding + 50
        
        return CGSize(width: availableWidth,
                      height: availableHeight)
    }
    
    /// Подписываем на класс на нотификацию
    private func signInNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeLayoutType),
                                               name: NSNotification.Name ("changeLayoutType"),
                                               object: nil)
    }
    
    /// Изменение `Layout` секции
    @objc private func changeLayoutType() {
        layoutType = layoutType == .split2xN ? .split1xN : .split2xN
    }
}

// MARK: - CVItemBuilderProtocol
extension MainItemBuilder: CVSelectableItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(FirstRecipeCell.self)
        collectionView.register(SecondRecipeCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(collectionView: UICollectionView) -> CGSize {
        calculateItemSize(width: collectionView.bounds.width)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        /// Получаем модель для ячейки
        let model = models[indexPath.item]
        /// Получаем вариант исполнения ячейки в зависимости от типа `Layout`
        let typeCell = layoutType == .split2xN ? FirstRecipeCell.self : SecondRecipeCell.self
        
        /// Создаем и настраиваем ячейку
        let cell = collectionView.dequeueReusableCell(typeCell,
                                                      indexPath: indexPath)
        cell.basketDelegate = delegate
        cell.favoriteDelegate = delegate
        cell.configure(with: model, type: .favorite)
        
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
