//
//  BasicInfoCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Ячейка основной информации Рецепта
final class BasicInfoCell: TVBaseCell {
    
    // MARK: - Properties
    /// Изображение рецепта
    private lazy var recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .orange
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    /// Кастомный вью с информацие о рецепте
    private lazy var detailTitleView: DetailTitleView = {
        let view = DetailTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Function
    override func setupCell() {
        setupConstraints()
    }
    
    func configure(with model: RecipeProtocol) {
        detailTitleView.titleRecipeLabel.text = model.title
        detailTitleView.cookingTimeLabel.text = model.cookingTime
        detailTitleView.numberServingsLabel.text = "\(model.servings) Порций"
        detailTitleView.layoutSubviews()
    }
    
    func updateImage(with imageData: Data) {
        if let image = UIImage(data: imageData) {
            recipeImageView.image = image
        } else {
            recipeImageView.image = UIImage(named: "defaultDish")
        }
    }
    
    private func setupConstraints() {
        addSubview(recipeImageView)
        addSubview(detailTitleView)
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 400),
            
            detailTitleView.centerYAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            detailTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailTitleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
