//
//  RLAdapter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.11.2022.
//

import UIKit

final class RLAdapter: NSObject {
    private let collectionView: UICollectionView
    var builders: [CVSectionBuilderProtocol] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func configure(with builders: [CVSectionBuilderProtocol]) {
        self.builders = builders
    }
}

extension RLAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        builders.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        builders[section]
            .itemBuilder
            .itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        builders[indexPath.section]
            .itemBuilder
            .cellAt(indexPath: indexPath, collectionView: collectionView)
    }
}

extension RLAdapter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        builders[indexPath.section]
            .itemBuilder
            .didSelectItem(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        builders[indexPath.section]
            .itemBuilder
            .itemSize(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        builders[indexPath.section]
            .headerBuilder?
            .viewSupplementaryElement(collectionView: collectionView,
                                      kind: kind,
                                      indexPath: indexPath) ?? UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        builders[section]
            .headerBuilder?
            .headerSize(collectionView: collectionView) ?? CGSize.zero
    }
}
