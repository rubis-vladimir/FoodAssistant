//
//  IngredientView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 21.12.2022.
//

import UIKit

/// #Вью с информацией об ингредиенте
final class IngredientView: UIView {
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
        label.numberOfLines = 0
        return label
    }()
    
    /// Лейбл под количество ингредиента
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.numberOfLines = 0
        label.textAlignment = .center
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
    
    /// Индикатор загрузки
    private lazy var spinner = BallSpinFadeLoader()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure(with ingredient: IngredientViewModel) {
        titleIngredientLabel.text = ingredient.name
        
        if ingredient.image != nil {
            addSubview(spinner)
            spinner.setupSpinner(loadingImageView: ingredientImageView)
        }
        
        var amountString = ""
        if ingredient.amount < 1 {
            let amountFraction = ingredient.amount.rationalApproximationOf()
            amountString = "\(amountFraction.0)/\(amountFraction.1)"
        } else {
            if (ingredient.amount - Float(Int(ingredient.amount))) == 0 {
                amountString = String(format: "%.0f", ingredient.amount)
            } else {
                amountString = String(format: "%.1f", ingredient.amount)
            }
        }
        
        var text = "\(amountString)"
        let unit = ingredient.unit.localize()
        print(ingredient.unit)
        if unit != "" {
            text += "\n\(unit)"
        }
        amountLabel.text = text
    }
    
    func updateImage(with imageData: Data) {
        spinner.removeFromSuperview()
        ingredientImageView.reloadInputViews()
        
        if let image = UIImage(data: imageData) {
            ingredientImageView.image = image
        } else {
            ingredientImageView.image = UIImage(named: "defaultIngredient")
        }
    }
    
    private func setupConstraints() {
        [ingredientImageView, amountLabel, titleIngredientLabel].forEach {
            container.addArrangedSubview($0)
        }
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ingredientImageView.widthAnchor.constraint(equalToConstant: 50),
            ingredientImageView.heightAnchor.constraint(equalToConstant: 50),
            amountLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
