//
//  RecommendedRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.11.2022.
//

import UIKit

/// #Ячейка коллекции для рекомендованных рецептов
final class ThirdRecipeCell: CVBaseRecipeCell {
    
    // MARK: - Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        addToBasketButton.layer.cornerRadius = addToBasketButton.frame.height / 2
    }
    
    override func configure(with model: RecipeViewModel, type: TypeOfActionButton) {
        super.configure(with: model, type: type)
        
        addToBasketButton.setTitle("\(addEnding(number: model.ingredientsCount))",
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
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        substrateTime.addArrangedSubview(cookingTimeLabel)
        containerTopLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(substrateTime)
        
        stack.addArrangedSubview(containerTopLabel)
        stack.addArrangedSubview(addToBasketButton)
        substrateAction.addSubview(actionButton)
        
        addSubview(recipeImageView)
        addSubview(stack)
        addSubview(substrateAction)
        
        /// Константы
        let padding: CGFloat = AppConstants.padding
        let heightOne: CGFloat = 30
        let heightTwo: CGFloat = 35
        let heightStack: CGFloat = 90
        let paddingCL: CGFloat = 5
        let widthAction: CGFloat = 27
        let heightAction: CGFloat = 26
        
        /// Настраиваем констрейнты
        NSLayoutConstraint.activate([
            substrateTime.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -padding),
            substrateTime.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: padding),
            substrateTime.heightAnchor.constraint(equalToConstant: heightOne),
            
            cookingTimeLabel.leadingAnchor.constraint(equalTo: substrateTime.leadingAnchor, constant: paddingCL),
            
            substrateAction.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.padding),
            substrateAction.topAnchor.constraint(equalTo: topAnchor, constant: AppConstants.padding),
            substrateAction.heightAnchor.constraint(equalToConstant: heightAction),
            substrateAction.widthAnchor.constraint(equalToConstant: widthAction),
            
            addToBasketButton.heightAnchor.constraint(equalToConstant: heightTwo),
            
            recipeImageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -padding),
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stack.heightAnchor.constraint(equalToConstant: heightStack),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
        ])
    }
    
    private func addEnding(number: Int) -> String {
        let endingBy10 = number % 10
        let endingBy100 = number % 100
        var baseString = "\(number) ИНГРЕДИЕНТ"
        
        switch endingBy10 {
        case 1:
            baseString += 11 == endingBy100 ? "ОВ" : ""
        case 2, 3, 4 :
            baseString += 12...14 ~= endingBy100 ? "ОВ" : "А"
        default:
            baseString += "ОВ"
        }
        return baseString
    }
}
