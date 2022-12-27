//
//  FilterView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 27.12.2022.
//

import UIKit

/// #Вью фильтра и его элементов
class FilterView: UIView {
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                 collectionViewLayout: getFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding = AppConstants.padding
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        return layout
    }
    
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView()
        stack.addArrangedSubview(collectionView)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12)
        ])
    }
}

