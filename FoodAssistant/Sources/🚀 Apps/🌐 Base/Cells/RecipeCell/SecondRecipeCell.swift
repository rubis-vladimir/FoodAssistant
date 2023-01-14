//
//  MainSecondRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 03.12.2022.
//

import UIKit

/// #Второй вариант ячейки Рецепта
final class SecondRecipeCell: CVBaseRecipeCell {
    
    // MARK: - Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        addToBasketButton.layer.cornerRadius = addToBasketButton.frame.height / 2
    }
    
    override func configure(with model: RecipeViewModel, type: TypeOfActionButton) {
        super.configure(with: model, type: type)
        
        addToBasketButton.setTitle("\(model.ingredientsCount)",
                                   for: .normal)
    }
    
    override func setupCell() {
        backgroundColor = Palette.bgColor.color
        clipsToBounds = true
        layer.cornerRadius = AppConstants.cornerRadius
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        
        super.setupCell()
    }
    
    /// Настройка констрейнтов
    override func setupConstraints() {
        super.setupConstraints()
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(cookingTimeLabel)
        stack.addArrangedSubview(addToBasketButton)
        
        addSubview(recipeImageView)
        addSubview(stack)
        addSubview(substrateAction)
        addSubview(containerTopLabel)
        
        /// Константы
        let padding: CGFloat = AppConstants.padding
        let height: CGFloat = 35
        let widthAction: CGFloat = 27
        let heightAction: CGFloat = 26
        let widthAB: CGFloat = 100
        let paddingMin: CGFloat = 5
        
        /// Настраиваем констрейнты
        NSLayoutConstraint.activate([
            
            recipeImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: containerTopLabel.leadingAnchor, constant: -padding),
            
            containerTopLabel.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -paddingMin),
            containerTopLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            containerTopLabel.trailingAnchor.constraint(equalTo: substrateAction.leadingAnchor, constant: -paddingMin),
            
            substrateAction.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            substrateAction.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            substrateAction.heightAnchor.constraint(equalToConstant: heightAction),
            substrateAction.widthAnchor.constraint(equalToConstant: widthAction),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: containerTopLabel.leadingAnchor),
            
            addToBasketButton.heightAnchor.constraint(equalToConstant: height),
            addToBasketButton.widthAnchor.constraint(equalToConstant: widthAB)
        ])
    }
}
