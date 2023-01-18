//
//  RLAdapter.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.11.2022.
//

import UIKit

/// #Адаптер для CollectionView
final class CVAdapter: NSObject {
    private var builders: [CVSectionProtocol] = []

    func configure(with builders: [CVSectionProtocol]) {
        self.builders = builders
    }
}

// MARK: - UICollectionViewDataSource
extension CVAdapter: UICollectionViewDataSource {
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

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        builders[indexPath.section]
            .headerBuilder?
            .viewSupplementaryElement(collectionView: collectionView,
                                      kind: kind,
                                      indexPath: indexPath) ?? UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension CVAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        /// Для ячеек с расширенной функциональностью
        if let itemBuilder = builders[indexPath.section].itemBuilder as? CVSelectableItemBuilderProtocol {
            itemBuilder.didSelectItem(indexPath: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        builders[indexPath.section]
            .itemBuilder
            .itemSize(indexPath: indexPath,
                      collectionView: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        builders[section]
            .headerBuilder?
            .headerSize(collectionView: collectionView) ?? CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        /// Для ячеек с другим layout
        if let itemBuilder = builders[section].itemBuilder as? CVSectionInsetProtocol {
            return itemBuilder.insetForSection()
        } else {
            return AppConstants.edgeInsertForSection
        }
    }
}
