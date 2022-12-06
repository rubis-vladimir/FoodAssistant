//
//  MainSecondRecipeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 03.12.2022.
//

import UIKit

/// #Второй вариант ячейки коллекции для секции Main !!!! ПОКА НЕ СДЕЛАН !!!
final class MainSecondRecipeCell: CVBaseRecipeCell {
    
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
    }
    
    override func configure(with model: RecipeModel) {
        super.configure(with: model)
        
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
        addSubview(favoriteButton)
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
            containerTitleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -paddingMin),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            favoriteButton.widthAnchor.constraint(equalToConstant: width),
            
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: containerTitleLabel.leadingAnchor),
            
            addToBasketButton.heightAnchor.constraint(equalToConstant: height),
            addToBasketButton.widthAnchor.constraint(equalToConstant: widthAB)
        ])
    }
}
