//
//  RecommendedRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.11.2022.
//

import UIKit

/// #Ячейка коллекции для рекомендованных рецептов
final class RecommendedRecipeCell: CVBaseRecipeCell {
    
    // MARK: - Properties
    weak var delegate: RLElementsCellDelegate?
    
    private lazy var addToBasketButton: UIButton = {
        var button = UIButton()
        button.setImage(Icons.basketSmall.image,
                        for: .normal)
        button.backgroundColor = Palette.darkColor.color
        button.titleLabel?.font = Fonts.main
        button.tintColor = .white
        button.layer.add(shadow: AppConstants.Shadow.defaultTwo)
        button.addTarget(self,
                         action: #selector(addToBasketButtonTapped),
                         for: .touchUpInside)
        button.imageEdgeInsets = AppConstants.edgeInsert
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        addToBasketButton.layer.cornerRadius = addToBasketButton.frame.height / 2
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
    }
    
    override func configure(with model: RecipeModel) {
        super.configure(with: model)
        
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
    
    /// Нажата кнопка изменения флага любимого рецепта
    @objc override func didFavoriteButtonToggle() {
        super.didFavoriteButtonToggle()
        
        guard let id = id else { return }
        delegate?.didTapFavoriteButton(isFavorite, type: .recommended, id: id)
    }
    
    /// Нажата кнопка добавления в корзину ингредиентов рецепта
    @objc func addToBasketButtonTapped() {
        guard let id = id else { return }
        delegate?.didTapAddIngredientsButton(type: .recommended, id: id)
    }
    
    /// Настройка констрейнтов
    func setupConstraints() {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        containerCookingLabel.addArrangedSubview(cookingTimeLabel)
        containerTitleLabel.addArrangedSubview(titleRecipeLabel)
        recipeImageView.addSubview(containerCookingLabel)
        
        stack.addArrangedSubview(containerTitleLabel)
        stack.addArrangedSubview(addToBasketButton)
        
        addSubview(recipeImageView)
        addSubview(stack)
        addSubview(favoriteButton)
        
        /// Константы
        let padding: CGFloat = AppConstants.padding
        let heightOne: CGFloat = 30
        let heightTwo: CGFloat = 35
        let heightStack: CGFloat = 90
        let paddingCL: CGFloat = 5
        
        /// Настраиваем констрейнты
        NSLayoutConstraint.activate([
            containerCookingLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -padding),
            containerCookingLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: padding),
            containerCookingLabel.heightAnchor.constraint(equalToConstant: heightOne),
            
            cookingTimeLabel.leadingAnchor.constraint(equalTo: containerCookingLabel.leadingAnchor, constant: paddingCL),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            
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
