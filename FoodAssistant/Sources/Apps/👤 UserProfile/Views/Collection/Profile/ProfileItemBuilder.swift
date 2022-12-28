//
//  ProfileItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Строитель ячеек секции RecommendedRecipe
final class ProfileItemBuilder {
    private let height: CGFloat = 300
}

// MARK: - RecommendedRecipeItemBuilder
extension ProfileItemBuilder: CVItemBuilderProtocol {
    
    func register(collectionView: UICollectionView) {
        collectionView.register(AvatarCell.self)
    }
    
    func itemCount() -> Int { 1 }
    
    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        CGSize(width: collectionView.bounds.width,
               height: height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(AvatarCell.self,
                                                      indexPath: indexPath)
        
        return cell
    }
}
