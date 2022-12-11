//
//  IngredientCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Ячейка с информацией об ингредиенте
final class IngredientCell: BaseTableViewCell {
    
    // MARK: - Properties
    /// Вью под изображение ингредиента
    private lazy var ingredientImageView: UIImageView = {
        let width: CGFloat = 50
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = width / 2
        view.clipsToBounds = true
        view.layer.add(shadow: AppConstants.Shadow.defaultOne)
        return view
    }()
    
    /// Лейбл под название ингредиента
    private lazy var titleIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.selected
        return label
    }()
    
    /// Лейбл под количество ингредиента
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Общий контейнер
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Functions
    override func setupCell() {
        setupConstraints()
    }
    
    func configure(with ingredient: IngredientProtocol) {
        titleIngredientLabel.text = ingredient.name
        amountLabel.text = "\(ingredient.amount ?? 0) \(ingredient.unit ?? "")"
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
            ingredientImageView.heightAnchor.constraint(equalToConstant: 50),
            amountLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
