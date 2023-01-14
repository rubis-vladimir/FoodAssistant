//
//  ProfileItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Строитель ячеек секции Profile
final class ProfileItemBuilder {
    /// Количество ячеек
    private let count = 1
    /// Высота ячеек
    private let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
}

// MARK: - CVItemBuilderProtocol
extension ProfileItemBuilder: CVItemBuilderProtocol {
    
    func register(collectionView: UICollectionView) {
        collectionView.register(AvatarCell.self)
    }
    
    func itemCount() -> Int { count }
    
    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        CGSize(width: AppConstants.calculateItemWidth(width: collectionView.bounds.width,
                                                      itemPerRow: 1,
                                                      padding: AppConstants.padding),
               height: height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(AvatarCell.self,
                                                      indexPath: indexPath)
        
        return cell
    }
}
