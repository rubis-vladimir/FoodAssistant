//
//  MainSecondRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 03.12.2022.
//

import UIKit

/// #Второй вариант ячейки коллекции для секции Main
final class MainSecondRecipeCell: CVBaseRecipeCell {
    
    weak var delegate: RLFavoriteChangable?
    
    // MARK: - Override func
    override func setupCell() {
        super.setupCell()
        setupConstraints()
    }
    
    @objc override func didFavoriteButtonToggle() {
        super.didFavoriteButtonToggle()
        
        guard let id = id else { return }
        delegate?.didTapFavoriteButton(isFavorite, type: .main, id: id)
    }
    
    // MARK: - Private func
    /// Настройка констрейнтов
    private func setupConstraints() {
        /// Основной стэк
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        /// Добавление элементов в слои
        containerCookingLabel.addArrangedSubview(cookingTimeLabel)
        containerTitleLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(containerCookingLabel)
        
        stack.addArrangedSubview(recipeImageView)
        stack.addArrangedSubview(containerTitleLabel)
        
        addSubview(stack)
        addSubview(favoriteButton)
        
        /// Констрейнты
        let heightOne: CGFloat = 30
        let heightTwo: CGFloat = 45
        let paddingCL: CGFloat = 5
        
        NSLayoutConstraint.activate([
            containerCookingLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -AppConstants.padding),
            containerCookingLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: AppConstants.padding),
            containerCookingLabel.heightAnchor.constraint(equalToConstant: heightOne),
            
            cookingTimeLabel.leadingAnchor.constraint(equalTo: containerCookingLabel.leadingAnchor, constant: paddingCL),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.padding),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: AppConstants.padding),
            
            containerTitleLabel.heightAnchor.constraint(equalToConstant: heightTwo),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
