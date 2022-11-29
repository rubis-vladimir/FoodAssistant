//
//  IngredientsCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

final class IngredientsCell: CustomTableViewCell {
    
    private lazy var ingredientImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.backgroundColor = Palette.bgColor.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.addShadow()
        
        return view
    }()
    
    private lazy var titleIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.selected
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func setupCell() {
        setupConstraints()
    }
    
    func configure(with ingredient: Ingredient) {
        titleIngredientLabel.text = ingredient.name
        amountLabel.text = "\(ingredient.amount ?? 0) \(ingredient.unit ?? ""))"
    }
    
    func updateImage(with imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        ingredientImageView.image = image
    }
    
    private func setupConstraints() {
        
        [ingredientImageView, amountLabel, titleIngredientLabel].forEach {
            container.addArrangedSubview($0)
        }
        
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            ingredientImageView.widthAnchor.constraint(equalToConstant: 50),
            amountLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
