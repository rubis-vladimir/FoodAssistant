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
    var isSelector: Bool

    weak var delegate: RLLayoutChangable?
    
    init(title: String,
         isSelector: Bool,
         delegate: RLLayoutChangable?) {
        self.title = title
        self.isSelector = isSelector
        self.delegate = delegate
    }
}

// MARK: - CVHeaderBuilderProtocol
extension MainHeaderBuilder: CVHeaderBuilderProtocol {
    
    func register(collectionView: UICollectionView) {
        collectionView.register(RLSectionHeader.self,
                                kind: UICollectionView.elementKindSectionHeader)
    }
    
    func viewSupplementaryElement(collectionView: UICollectionView,
                                  kind: String,
                                  indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableView(RLSectionHeader.self,
                                                                kind: kind,
                                                                indexPath: indexPath)
            headerView.delegate = delegate
            headerView.configure(title: title,
                                 isSelector: isSelector)
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func headerSize(collectionView: UICollectionView) -> CGSize {
        .init(width: collectionView.bounds.width, height: height)
    }
}
