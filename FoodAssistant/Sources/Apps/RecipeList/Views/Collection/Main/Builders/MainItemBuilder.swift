//
//  MainItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

enum LayoutType {
    case split2xN
    case split1xN
}

// Строитель ячеек секции Main
final class MainItemBuilder {
    private let height: CGFloat = 300
    private let models: [RecipeCellModel]
    private let layoutType: LayoutType
    
    weak var delegate: RecipeListPresentation?
    
    init(models: [RecipeCellModel],
         layoutType: LayoutType,
         delegate: RecipeListPresentation?) {
        self.models = models
        self.layoutType = layoutType
        self.delegate = delegate
    }
    
    private func calculateItemSize(width: CGFloat) -> CGSize {
        let padding: CGFloat = 16
        let itemPerRow: CGFloat = 2
        let paddingWidht = padding * (itemPerRow + 1)
        let availableWidth = (width - paddingWidht) / itemPerRow
        return CGSize(width: availableWidth,
                      height: availableWidth + padding + 40)
    }
}

extension MainItemBuilder: CVItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(MainRecipeCell.self)
    }
    
    func itemCount() -> Int { models.count }
    
    func itemSize(collectionView: UICollectionView) -> CGSize {
        calculateItemSize(width: collectionView.bounds.width)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        
        switch layoutType {
            
        case .split2xN:
            let cell = collectionView.dequeueReusableCell(MainRecipeCell.self,
                                                          indexPath: indexPath)
            let model = models[indexPath.item]
            cell.delegate = delegate
            cell.configure(with: model)
            if let imageName = model.imageName {
                delegate?.fetchImage(with: imageName, size: .medium) { imageData in
                    DispatchQueue.main.async {
                        cell.updateRecipeImage(data: imageData)
                    }
                }
            }
            
            return cell
        case .split1xN:
            let cell = collectionView.dequeueReusableCell(MainRecipeCell.self,
                                                          indexPath: indexPath)
            cell.delegate = delegate
            cell.configure(with: models[indexPath.item])
            return cell
        }
    }
    
    func didSelectItem(indexPath: IndexPath) {
        let model = models[indexPath.item]
        print("GO TO MODEL \(model)")
        delegate?.didSelectItem(type: .recommended,
                                id: indexPath.row)
    }
}
