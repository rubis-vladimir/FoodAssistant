//
//  TimersItemBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.01.2023.
//

import UIKit

/// #Строитель ячеек секции Timers
final class TimersItemBuilder {
    private let height: CGFloat
    private let timers: [RecipeTimer]
    
    init(height: CGFloat,
         timers: [RecipeTimer]) {
        self.height = height
        self.timers = timers
    }
}

// MARK: - CVItemBuilderProtocol
extension TimersItemBuilder: CVSelectableItemBuilderProtocol {
   

    func register(collectionView: UICollectionView) {
        collectionView.register(TimerCell.self)
    }
    
    func itemCount() -> Int { timers.count }
    
    func itemSize(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        CGSize(width: collectionView.bounds.width,
               height: height)
    }
    
    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(TimerCell.self,
                                                      indexPath: indexPath)
        
        return cell
    }
    
    func didSelectItem(indexPath: IndexPath) {
        print("TIMER CHECK")
    }
}
