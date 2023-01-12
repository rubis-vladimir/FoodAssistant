//
//  HeaderBuilder.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 25.11.2022.
//

import UIKit

/// #Варианты заголовков
enum HeaderType {
    /// Базовый с лейблом
    case base(title: String)
    /// С лейблом и кнопкой
    case withButton(headerModel: HeaderSectionModel)
}

/// #Строитель заголовка секции Main
final class HeaderBuilder {
    private let height: CGFloat = AppConstants.heightHeader
    private let type: HeaderType
    
    init(type: HeaderType) {
        self.type = type
    }
}

// MARK: - CVHeaderBuilderProtocol
extension HeaderBuilder: CVHeaderBuilderProtocol {
    
    func register(collectionView: UICollectionView) {
        collectionView.register(CVSectionHeaderWithButton.self,
                                kind: UICollectionView.elementKindSectionHeader)
        collectionView.register(CVBaseSectionHeader.self,
                                kind: UICollectionView.elementKindSectionHeader)
    }
    
    func viewSupplementaryElement(collectionView: UICollectionView,
                                  kind: String,
                                  indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            switch type {
            case .base(let title):
                let headerView = collectionView.dequeueReusableView(CVBaseSectionHeader.self,
                                                                    kind: kind,
                                                                    indexPath: indexPath)
                headerView.configure(title: title)
                return headerView
                
            case  .withButton(let headerModel):
                let headerView = collectionView.dequeueReusableView(CVSectionHeaderWithButton.self,
                                                                    kind: kind,
                                                                    indexPath: indexPath)
                headerView.configure(model: headerModel,
                                     section: indexPath.section)
                return headerView
            }
        default:
            assert(false, "Недействительный тип элемента")
        }
    }
    
    func headerSize(collectionView: UICollectionView) -> CGSize {
        .init(width: collectionView.bounds.width, height: height)
    }
}
