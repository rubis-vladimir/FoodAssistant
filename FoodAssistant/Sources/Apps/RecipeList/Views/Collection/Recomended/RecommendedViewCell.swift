//
//  RecommendedViewCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.11.2022.
//

import UIKit

final class RecommendedViewCell: UICollectionViewCell {
    
    weak var delegate: RecipeListPresentation?
    
    private var recipeListAdapter: CVAdapter?
    
    private lazy var collectionView: UICollectionView = {
        let layout = setupLayout()
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        recipeListAdapter = CVAdapter(collectionView: collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with models: [RecipeCellModel]) {
        let builders = [
            RecommendedRecipeSectionConfigurator(collectionView: collectionView,
                                                            models: models,
                                                            delegate: delegate).configure()
        ]
        recipeListAdapter?.configure(with: builders)
    }
    
    private func setupConstraints() {
        collectionView.dataSource = recipeListAdapter
        collectionView.delegate = recipeListAdapter
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: 0,
                                           right: padding)
        
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        backgroundColor = .none
        return layout
    }
}
