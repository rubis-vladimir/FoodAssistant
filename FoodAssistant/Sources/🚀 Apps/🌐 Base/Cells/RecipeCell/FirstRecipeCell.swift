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

        recipeImageView.layer.cornerRadius = AppConstants.cornerRadius
        super.setupCell()
    }

    // MARK: - Private func
    /// Настройка констрейнтов
    override func setupConstraints() {
        super.setupConstraints()

        /// Добавление элементов в слои
        substrateTime.addArrangedSubview(cookingTimeLabel)
        containerTopLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(substrateTime)

        addSubview(recipeImageView)
        addSubview(containerTopLabel)
        addSubview(substrateAction)

        /// Констрейнты
        let padding: CGFloat = AppConstants.padding
        let heightOne: CGFloat = 30
        let heightTwo: CGFloat = 45
        let widthAction: CGFloat = 27
        let heightAction: CGFloat = 26

        NSLayoutConstraint.activate([
            substrateTime.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -padding),
            substrateTime.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: padding),
            substrateTime.heightAnchor.constraint(equalToConstant: heightOne),

            substrateAction.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -padding),
            substrateAction.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: padding),
            substrateAction.heightAnchor.constraint(equalToConstant: heightAction),
            substrateAction.widthAnchor.constraint(equalToConstant: widthAction),

            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            containerTopLabel.heightAnchor.constraint(equalToConstant: heightTwo),
            containerTopLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerTopLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            containerTopLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerTopLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
