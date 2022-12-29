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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ingredientView.layer.cornerRadius = ingredientView.frame.height / 2
    }
    
    func configure(with ingredient: IngredientViewModel, flag: Bool) {
        ingredientView.configure(with: ingredient)
        
        if flag {
            ingredientView.backgroundColor = Palette.bgColor.color
            ingredientView.layer.borderWidth = 0.5
            ingredientView.layer.borderColor = UIColor.lightGray.cgColor
            ingredientView.layoutSubviews()
        } else {
            ingredientView.layer.borderColor = UIColor.clear.cgColor
            ingredientView.backgroundColor = .clear
        }
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
