//
//  TVIngredientCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Ячейка с информацией об ингредиенте
final class TVIngredientCell: TVBaseCell {
    
    // MARK: - Properties
    private lazy var ingredientView = IngredientView()
    
    // MARK: - Functions
    override func setupCell() {
        setupConstraints()
    }
    
    func configure(with ingredient: IngredientViewModel) {
        ingredientView.configure(with: ingredient)
    }
    
    func updateImage(with imageData: Data) {
        ingredientView.updateImage(with: imageData)
    }
    
    private func setupConstraints() {
        addSubview(ingredientView)
        
        NSLayoutConstraint.activate([
            ingredientView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            ingredientView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            ingredientView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ingredientView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
