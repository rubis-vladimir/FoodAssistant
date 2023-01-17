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
        CGSize(width: AppConstants.calculateItemWidth(width: collectionView.bounds.width,
                                                      itemPerRow: 2,
                                                      padding: AppConstants.padding),
               height: height)
    }

    func cellAt(indexPath: IndexPath,
                collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(TimerCell.self,
                                                      indexPath: indexPath)
        let timer = timers[indexPath.item]
        cell.configure(with: timer,
                       index: indexPath.item)

        return cell
    }

    func didSelectItem(indexPath: IndexPath) {
        print("TIMER CHECK")
    }
}
