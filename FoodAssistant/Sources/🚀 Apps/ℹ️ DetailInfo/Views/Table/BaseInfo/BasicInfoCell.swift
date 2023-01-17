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
    let servingsText = "Servings".localize()

    /// Изображение рецепта
    private lazy var recipeImageView: UIImageView = {
        let imv = UIImageView()
        imv.backgroundColor = .orange
        imv.contentMode = .scaleAspectFill
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()

    /// Кастомный вью с информацие о рецепте
    private lazy var detailTitleView: DetailTitleView = {
        let view = DetailTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Function
    override func setupCell() {
        backgroundColor = .clear
        setupConstraints()
    }

    func configure(with model: RecipeProtocol) {
        detailTitleView.titleRecipeLabel.text = model.title
        detailTitleView.cookingTimeLabel.text = model.cookingTime
        detailTitleView.numberServingsLabel.text = "\(model.servings) \(servingsText)"
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

        let padding = AppConstants.padding

        let heightAnchor = recipeImageView.heightAnchor.constraint(equalToConstant: 350)
        heightAnchor.priority = .defaultHigh

        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor,

            detailTitleView.centerYAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            detailTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            detailTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            detailTitleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
