//
//  RecommendedRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.11.2022.
//

import UIKit

final class RecommendedRecipeCell: MainRecipeCell {
    
    let addToBasketButton: UIButton = {
        var button = UIButton()
        button.setImage(Icons.basketSmall.image, for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.titleLabel?.font = Fonts.main
        button.layer.add(shadow: AppConstants.Shadow.defaultTwo)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addToBasketButton.layer.cornerRadius = addToBasketButton.frame.height / 2
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
    }
    
    @objc func addToBasketButtonTapped() {
        print("addToBasketButtonTapped")
    }
    
    override func configure(with model: RecipeCellModel) {
        addToBasketButton.setTitle("\(addEnding(number: model.ingredientsCount))",
                                   for: .normal)
        titleRecipeLabel.text = model.titleRecipe
        cookingTimeLabel.text = model.cookingTime + " "
        
        if let urlString = model.imageName {
            let imageName = urlString.dropFirst(37)
            print(imageName)
            addSubview(activity)
            activity.setUpSpinner(loadingImageView: recipeImageView)
        }
    }
    
    override func setupCell() {
        backgroundColor = Palette.bgColor.color
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        
        favoriteButton.setImage(Icons.heart.image, for: .normal)
        favoriteButton.addTarget(self,
                                 action: #selector(didFavoriteButtonToggle),
                                 for: .touchUpInside)
        addToBasketButton.addTarget(self,
                                    action: #selector(addToBasketButtonTapped),
                                    for: .touchUpInside)
    }
    
    override func setupConstraints() {
        
        let containerForLabel = UIStackView()
        containerForLabel.axis = .horizontal
        containerForLabel.alignment = .top
        containerForLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.spacing = 0
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        addToBasketButton.imageEdgeInsets = AppConstants.edgeInsert
        
        containerForCTLabel.addArrangedSubview(cookingTimeLabel)
        containerForLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(containerForCTLabel)
        
        stack.addArrangedSubview(containerForLabel)
        stack.addArrangedSubview(addToBasketButton)
        
        addSubview(recipeImageView)
        addSubview(stack)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            containerForCTLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -16),
            containerForCTLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 16),
            containerForCTLabel.heightAnchor.constraint(equalToConstant: 30),
            
            cookingTimeLabel.leadingAnchor.constraint(equalTo: containerForCTLabel.leadingAnchor, constant: 4),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            addToBasketButton.heightAnchor.constraint(equalToConstant: 35),
            
            recipeImageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -16),
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stack.heightAnchor.constraint(equalToConstant: 90),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        addSubview(activity)
        activity.setUpSpinner(loadingImageView: recipeImageView)
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
