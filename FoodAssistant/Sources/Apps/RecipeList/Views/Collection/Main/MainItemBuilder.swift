//
//  MainItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Варианты `Layout
enum LayoutType {
    /// Две в ряду
    case split2xN
    /// Одна в ряду
    case split1xN
}

/// #Строитель ячеек секции Main
final class MainItemBuilder {
    
    private var layoutType: LayoutType = .split2xN
    private let models: [RecipeModel]
    
    weak var delegate: RecipeListPresentation?
    
    init(models: [RecipeModel],
         delegate: RecipeListPresentation?) {
        self.models = models
        self.delegate = delegate
        
        signInNotification()
    }
    
    /// Рассчитывает размер ячеек
    private func calculateItemSize(width: CGFloat) -> CGSize {
        let padding: CGFloat = AppConstants.padding
        var itemPerRow: CGFloat = 0
        switch layoutType {
        case .split2xN: itemPerRow = 2
        case .split1xN: itemPerRow = 2
        }
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (width - paddingWidht) / itemPerRow
        return CGSize(width: availableWidth,
                      height: availableWidth + padding + 50)
    }
    
    /// Подписываем на класс на нотификацию
    private func signInNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeLayoutType),
                                               name: NSNotification.Name ("changeLayoutType"),
                                               object: nil)
    }
    
    /// Изменение
    @objc private func changeLayoutType() {
        layoutType = layoutType == .split2xN ? .split1xN : .split2xN
    }
}

// MARK: - CVItemBuilderProtocol
extension MainItemBuilder: CVItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(MainFirstRecipeCell.self)
        collectionView.register(RecommendedRecipeCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(collectionView: UICollectionView) -> CGSize {
        calculateItemSize(width: collectionView.bounds.width)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        
        switch layoutType {
            
        case .split2xN:
            let cell = collectionView.dequeueReusableCell(MainFirstRecipeCell.self,
                                                          indexPath: indexPath)
            let model = models[indexPath.item]
            cell.delegate = delegate
            cell.configure(with: model)
            if let imageName = model.imageName {
                delegate?.fetchImage(with: imageName) { imageData in
                    DispatchQueue.main.async {
                        cell.updateImage(data: imageData)
                    }
                }
            }
            
            return cell
        case .split1xN:
            let cell = collectionView.dequeueReusableCell(RecommendedRecipeCell.self,
                                                          indexPath: indexPath)
            let model = models[indexPath.item]
            cell.delegate = delegate
            cell.configure(with: model)
            if let imageName = model.imageName {
                delegate?.fetchImage(with: imageName) { imageData in
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
        delegate?.didSelectItem(type: .recommended,
                                id: model.id)
    }
}
