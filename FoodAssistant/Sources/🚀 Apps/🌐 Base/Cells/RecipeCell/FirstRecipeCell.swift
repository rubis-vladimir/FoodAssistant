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
        substrateTime.addArrangedSubview(cookingTimeLabel)
        substrateAction.addSubview(actionButton)
        containerTopLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(substrateTime)
        
        stack.addArrangedSubview(recipeImageView)
        stack.addArrangedSubview(containerTopLabel)
        
        addSubview(stack)
        addSubview(substrateAction)
        
        /// Констрейнты
        let heightOne: CGFloat = 30
        let heightTwo: CGFloat = 45
        let paddingCL: CGFloat = 5
        let widthAction: CGFloat = 27
        let heightAction: CGFloat = 26
        
        NSLayoutConstraint.activate([
            substrateTime.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -AppConstants.padding),
            substrateTime.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: AppConstants.padding),
            substrateTime.heightAnchor.constraint(equalToConstant: heightOne),
            
            cookingTimeLabel.leadingAnchor.constraint(equalTo: substrateTime.leadingAnchor, constant: paddingCL),
            
            substrateAction.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.padding),
            substrateAction.topAnchor.constraint(equalTo: topAnchor, constant: AppConstants.padding),
            substrateAction.heightAnchor.constraint(equalToConstant: heightAction),
            substrateAction.widthAnchor.constraint(equalToConstant: widthAction),
            
            containerTopLabel.heightAnchor.constraint(equalToConstant: heightTwo),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}



