//
//  RecommendedViewCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.11.2022.
//

import UIKit

final class RecommendedViewCell: UICollectionViewCell {
    
    weak var delegate: RecipeListPresentation?
    
    private var models: [RecipeCellModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = setupLayout()
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(RecommendedRecipeCell.self)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    func configure(with: [RecipeCellModel]) {
        models = with
    }
    
    func setupConstraints() {
        addSubview(collectionView)
        collectionView.pinEdges(to: self)
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: 0,
                                           right: padding)
        
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: bounds.width * 0.6, height: bounds.height)
        backgroundColor = .none
        return layout
    }
}


extension RecommendedViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecommendedRecipeCell.self, indexPath: indexPath)
        
        let recipeModel = models[indexPath.row]
        cell.configure(with: recipeModel)
        if let imageName = recipeModel.imageName {
            delegate?.fetchImage(with: imageName) { imageData in
                DispatchQueue.main.async {
                    cell.updateRecipeImage(data: imageData)
                }
            }
        }
        return cell
    }
}
