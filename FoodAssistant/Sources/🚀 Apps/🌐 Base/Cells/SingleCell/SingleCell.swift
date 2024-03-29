//
//  SingleCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.12.2022.
//

import UIKit

/// #Ячейка для размещения горизонтальной коллекции
final class SingleCell: UICollectionViewCell {
    // MARK: - Properties
    /// Адаптер для конфигурации внутренней коллекции
    private var recipeListAdapter: CVAdapter?
    /// Внутренняя коллекция
    private lazy var collectionView: UICollectionView = {
        let layout = setupLayout()
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        recipeListAdapter = CVAdapter()

        collectionView.dataSource = recipeListAdapter
        collectionView.delegate = recipeListAdapter

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    /// Конфигурирует внутреннюю коллекцию по переданному массиву моделей
    func configure(with configurators: [CVSectionConfiguration]) {
        /// Конфигурируем строитель секции

        guard !configurators.isEmpty else { return }

        let builders = configurators.map { $0.configure(for: collectionView) }

        /// Передаем в адаптер для обновления коллекции
        recipeListAdapter?.configure(with: builders)
        collectionView.reloadData()
    }

    /// Настройка констрейнтов
    private func setupConstraints() {

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    /// Настройка `Layout`
    private func setupLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = AppConstants.padding
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: 0,
                                           right: padding)

        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.scrollDirection = .horizontal
        backgroundColor = .none
        return layout
    }
}
