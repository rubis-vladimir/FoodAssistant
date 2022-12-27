//
//  TagCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.12.2022.
//

import UIKit

/// #Строитель для Tag ячеек
final class TagCellBuilder {
    
    private let tagModels: [TagModel]
    
    weak var delegate: RecipeFilterPresentation?
    
    init(tagModels: [TagModel],
         delegate: RecipeFilterPresentation?) {
        self.tagModels = tagModels
        self.delegate = delegate
    }
    
    /// Рассчитывает размеры ячейки
    private func calculateItemSize(index: Int,
                                   width: CGFloat) -> CGSize {
        let title = tagModels[index].title
        let size: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: Fonts.subtitle?.withSize(25) ?? UIFont.systemFont(ofSize: 25)])
        
        let availableWidth = size.width > width ? width - 20 : size.width
        let availableHeight = size.height

        return CGSize(width: availableWidth,
                      height: availableHeight)
    }
}

// MARK: - CVItemBuilderProtocol
extension TagCellBuilder: CVItemBuilderProtocol {

    func register(collectionView: UICollectionView) {
        collectionView.register(CVTagCell.self)
    }
    
    func itemCount() -> Int { tagModels.count }
    
    func itemSize(indexPath: IndexPath,
                  collectionView: UICollectionView) -> CGSize {
        calculateItemSize(index: indexPath.item,
                          width: collectionView.frame.width)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        /// Название
        let title = tagModels[indexPath.item].title
        ///
        let size = title.size(withAttributes: [NSAttributedString.Key.font: Fonts.subtitle?.withSize(25) ?? UIFont.systemFont(ofSize: 25)])
        
        let isCheck = delegate?.checkFlag(indexPath: indexPath) ?? false
        
        let cell = collectionView.dequeueReusableCell(CVTagCell.self,
                                                      indexPath: indexPath)
        cell.delegate = delegate
        cell.configure(flag: isCheck, title: title, indexPath: indexPath, height: size.height)
        
        return cell
    }
}

