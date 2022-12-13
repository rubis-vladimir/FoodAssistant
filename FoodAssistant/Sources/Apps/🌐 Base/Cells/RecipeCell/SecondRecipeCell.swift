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
    
    override func configure(with model: RecipeViewModel, type: TypeOfButton) {
        super.configure(with: model, type: type)
        
        addToBasketButton.setTitle("\(model.ingredientsCount)",
                                   for: .normal)
    }
    
    override func setupCell() {
        super.setupCell()
        backgroundColor = Palette.bgColor.color
        clipsToBounds = true
        layer.cornerRadius = AppConstants.cornerRadius
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        
        setupConstraints()
    }
    
    /// Настройка констрейнтов
    private func setupConstraints() {
        
        titleRecipeLabel.numberOfLines = 0
        containerTitleLabel.addArrangedSubview(titleRecipeLabel)
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(cookingTimeLabel)
        stack.addArrangedSubview(addToBasketButton)
        
        addSubview(recipeImageView)
        addSubview(stack)
        addSubview(actionButton)
        addSubview(containerTitleLabel)
        
        /// Константы
        let padding: CGFloat = AppConstants.padding
        let height: CGFloat = 35
        let width: CGFloat = 30
        let widthAB: CGFloat = 100
        let paddingMin: CGFloat = 5
        
        /// Настраиваем констрейнты
        NSLayoutConstraint.activate([
            
            recipeImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: containerTitleLabel.leadingAnchor, constant: -padding),
            
            containerTitleLabel.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -paddingMin),
            containerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            containerTitleLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -paddingMin),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            actionButton.widthAnchor.constraint(equalToConstant: width),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: containerTitleLabel.leadingAnchor),
            
            addToBasketButton.heightAnchor.constraint(equalToConstant: height),
            addToBasketButton.widthAnchor.constraint(equalToConstant: widthAB)
        ])
    }
}
