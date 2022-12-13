//
//  FavoriteItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 09.12.2022.
//

import UIKit

/// #Строитель ячеек секции Favorite
final class FavoriteItemBuilder {
    
    private var layoutType: LayoutType = .split1xN
    private let models: [RecipeViewModel]
    
    weak var delegate: UserProfilePresentation?
    
    init(models: [RecipeViewModel],
         delegate: UserProfilePresentation?) {
        self.models = models
        self.delegate = delegate
        
        signInNotification()
    }
    
    /// Рассчитывает размер ячеек
    private func calculateItemSize(width: CGFloat) -> CGSize {
        let padding: CGFloat = AppConstants.padding
        let itemPerRow: CGFloat = layoutType == .split1xN ? 1 : 2
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (width - paddingWidht) / itemPerRow
        let availableHeight = layoutType == .split1xN ? 125 : availableWidth + padding + 100
        
        return CGSize(width: availableWidth,
                      height: availableHeight)
    }
    
    /// Подписываем на класс на нотификацию
    private func signInNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeLayoutType),
                                               name: NSNotification.Name ("changeLayoutType2"),
                                               object: nil)
    }
    
    /// Изменение
    @objc private func changeLayoutType() {
        layoutType = layoutType == .split2xN ? .split1xN : .split2xN
    }
}

// MARK: - CVItemBuilderProtocol
extension FavoriteItemBuilder: CVItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(ThirdRecipeCell.self)
        collectionView.register(SecondRecipeCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(collectionView: UICollectionView) -> CGSize {
        calculateItemSize(width: collectionView.bounds.width)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        
        switch layoutType {
            
        case .split2xN:
            let cell = collectionView.dequeueReusableCell(ThirdRecipeCell.self,
                                                          indexPath: indexPath)
            let model = models[indexPath.item]
            cell.delegate = delegate
            cell.configure(with: model, type: .delete)
            if let imageName = model.imageName {
                delegate?.fetchRecipeImage(with: imageName) { imageData in
                    DispatchQueue.main.async {
                        cell.updateImage(data: imageData)
                    }
                }
            }
            
            return cell
        case .split1xN:
            let cell = collectionView.dequeueReusableCell(SecondRecipeCell.self,
                                                          indexPath: indexPath)
            let model = models[indexPath.item]
            cell.delegate = delegate
            cell.configure(with: model, type: .delete)
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
    
    func didSelectItem(indexPath: IndexPath) {
        let model = models[indexPath.item]
        delegate?.didSelectItem(id: model.id)
    }
}
