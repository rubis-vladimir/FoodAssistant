//
//  SingleCellBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Строитель ячейки для размещения горизонтальной коллекции
final class SingleCellBuilder {
    private let count = 1
    private let height: CGFloat
    private let configurators: [CVSectionConfiguration]
    
    init(height: CGFloat,
         configurators: [CVSectionConfiguration]) {
        self.height = height
        self.configurators = configurators
    }
}

// MARK: - CVItemBuilderProtocol
extension SingleCellBuilder: CVItemBuilderProtocol {
    
    
    func register(collectionView: UICollectionView) {
        collectionView.register(SingleCell.self)
    }
    
    func itemCount() -> Int { count }
    
    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        CGSize(width: collectionView.bounds.width,
               height: height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SingleCell.self,
                                                      indexPath: indexPath)
        cell.configure(with: configurators)
        return cell
    }
}
