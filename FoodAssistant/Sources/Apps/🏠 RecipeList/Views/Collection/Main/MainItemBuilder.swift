//
//  MainItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Варианты Layout
enum LayoutType {
    /// Две в ряду
    case split2xN
    /// Одна в ряду
    case split1xN
}

/// #Строитель ячеек секции Main
final class MainItemBuilder {
    
    private var layoutType: LayoutType = .split2xN
    private let models: [RecipeViewModel]
    
    var cellAction: ((IndexPath) -> Void)?
    
    weak var delegate: RecipeListPresentation?
    
    init(models: [RecipeViewModel],
         delegate: RecipeListPresentation?) {
        self.models = models
        self.delegate = delegate
        
        signInNotification()
        
        cellAction = { indexPath in
            let model = models[indexPath.item]
            delegate?.didSelectItem(id: model.id)
        }
    }
    
    /// Рассчитывает размер ячеек
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
    
    /// Изменение
    @objc private func changeLayoutType() {
        layoutType = layoutType == .split2xN ? .split1xN : .split2xN
    }
}

// MARK: - CVItemBuilderProtocol
extension MainItemBuilder: CVItemBuilderProtocol {

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
        
        switch layoutType {
            
        case .split2xN:
            let cell = collectionView.dequeueReusableCell(FirstRecipeCell.self,
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
            let cell = collectionView.dequeueReusableCell(SecondRecipeCell.self,
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
        delegate?.didSelectItem(id: model.id)
    }
}
