//
//  MainRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 18.11.2022.
//

import UIKit

/// #Ячейка коллекции для секции Main
final class FirstRecipeCell: CVBaseRecipeCell {
    
    // MARK: - Override func
    override func setupCell() {
        super.setupCell()
        recipeImageView.layer.cornerRadius = AppConstants.cornerRadius
        
        setupConstraints()
    }
    
    // MARK: - Private func
    /// Настройка констрейнтов
    private func setupConstraints() {
        /// Основной стэк
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        /// Добавление элементов в слои
        containerCookingLabel.addArrangedSubview(cookingTimeLabel)
        containerTitleLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(containerCookingLabel)
        
        stack.addArrangedSubview(recipeImageView)
        stack.addArrangedSubview(containerTitleLabel)
        
        addSubview(stack)
        addSubview(actionButton)
        
        /// Констрейнты
        let heightOne: CGFloat = 30
        let heightTwo: CGFloat = 45
        let paddingCL: CGFloat = 5
        
        NSLayoutConstraint.activate([
            containerCookingLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -AppConstants.padding),
            containerCookingLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: AppConstants.padding),
            containerCookingLabel.heightAnchor.constraint(equalToConstant: heightOne),
            
            cookingTimeLabel.leadingAnchor.constraint(equalTo: containerCookingLabel.leadingAnchor, constant: paddingCL),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.padding),
            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: AppConstants.padding),
            
            containerTitleLabel.heightAnchor.constraint(equalToConstant: heightTwo),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}



