//
//  MainHeaderBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

// Строитель заголовка секции Main
final class MainHeaderBuilder {
    private let height: CGFloat = 45
    var title: String
    var selector: Selector?
    
    init(title: String,
         selector: Selector?) {
        self.title = title
        self.selector = selector
    }
}

// MARK: - CVHeaderBuilderProtocol
extension MainHeaderBuilder: CVHeaderBuilderProtocol {
    
    func register(collectionView: UICollectionView) {
        collectionView.register(CustomSectionHeader.self,
                                kind: UICollectionView.elementKindSectionHeader)
    }
    
    func viewSupplementaryElement(collectionView: UICollectionView,
                                  kind: String,
                                  indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableView(CustomSectionHeader.self,
                                                                kind: kind,
                                                                indexPath: indexPath)
            headerView.configure(title: title,
                                 selector: selector)
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func headerSize(collectionView: UICollectionView) -> CGSize {
        .init(width: collectionView.frame.width, height: height)
    }
}
