//
//  CVIngredientCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 10.12.2022.
//

import UIKit

final class CVIngredientCell: UICollectionViewCell {
    
    // MARK: - Properties
    /// Вью под изображение ингредиента
    private lazy var ingredientImageView: UIImageView = {
        let width: CGFloat = 50
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.layer.add(shadow: AppConstants.Shadow.defaultOne)
        return view
    }()
    
    /// Лейбл под название ингредиента
    private lazy var titleIngredientLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
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
    
    private lazy var useIngredientButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.circle.image, for: .normal)
        button.tintColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setupCell() {
        setupConstraints()
    }
    
    func configure(with ingredient: IngredientProtocol) {
        titleIngredientLabel.text = ingredient.name
        amountLabel.text = "\(ingredient.amount) \(ingredient.unit ?? "")"
    }
    
    func updateImage(with imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        ingredientImageView.image = image
    }
    
    private func setupConstraints() {
        [ingredientImageView, amountLabel, titleIngredientLabel, useIngredientButton].forEach {
            container.addArrangedSubview($0)
        }
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ingredientImageView.widthAnchor.constraint(equalToConstant: 50),
//            ingredientImageView.heightAnchor.constraint(equalToConstant: 50),
            amountLabel.widthAnchor.constraint(equalToConstant: 50),
            useIngredientButton.widthAnchor.constraint(equalTo: container.heightAnchor)
        ])
    }
}
