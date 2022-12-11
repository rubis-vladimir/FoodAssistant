//
//  RecommendedViewBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.11.2022.
//

import UIKit

/// #Строитель ячеек секции Recommended
final class RecommendedItemBuilder {
    private let count = 1
    private let height: CGFloat = 320
    private let models: [RecipeViewModel]
    
    weak var delegate: RecipeListPresentation?
    
    init(models: [RecipeViewModel],
         delegate: RecipeListPresentation?) {
        self.models = models
        self.delegate = delegate
    }
}

// MARK: - RecommendedItemBuilder
extension RecommendedItemBuilder: CVItemBuilderProtocol {
    func register(collectionView: UICollectionView) {
        collectionView.register(RecommendedViewCell.self)
    }
    
    func itemCount() -> Int { count }
    
    func itemSize(collectionView: UICollectionView) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecommendedViewCell.self,
                                                      indexPath: indexPath)
        cell.delegate = delegate
        cell.configure(with: models)
        return cell
    }
}
