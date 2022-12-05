//
//  NutrientsCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

///
final class NutrientsCell: BaseTableViewCell {
    
    // MARK: - Properties
    private var numberServingsLabel: [UILabel] = []
    
    private let container: UIStackView = {
       let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    convenience init(nutrition: Nutrition) {
        self.init()
        configure(with: nutrition)
        container.backgroundColor = Palette.bgColor.color
        container.layer.add(shadow: AppConstants.Shadow.defaultOne)
        container.layer.cornerRadius = AppConstants.cornerRadius
    }
    
    // MARK: - Function
    func configure(with nutrition: Nutrition) {
        
        if let calories = nutrition.calories {
            let stack = createStack(title: Nutrients.calories.rawValue, number: calories)
            container.addArrangedSubview(stack)
        }
        if let protein = nutrition.protein {
            let stack = createStack(title: Nutrients.protein.rawValue, number: protein)
            container.addArrangedSubview(stack)
        }
        if let fats = nutrition.fats {
            let stack = createStack(title: Nutrients.fats.rawValue, number: fats)
            container.addArrangedSubview(stack)
        }
        if let carbohydrates = nutrition.carbohydrates {
            let stack = createStack(title: Nutrients.carbohydrates.rawValue, number: carbohydrates)
            container.addArrangedSubview(stack)
        }
    }
    
    override func setupCell() {
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    /// Создает стэк из лейблов
    ///  - Parameters:
    ///   - title: название питательного вещества
    ///   - number: количество питательного вещества
    ///  - Returns: стэк
    private func createStack(title: String,
                             number: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 8
        
        let titleLabel = UILabel()
        let numberLabel = UILabel()
        
        titleLabel.text = title
        numberLabel.text = number
        titleLabel.font = Fonts.main
        numberLabel.font = Fonts.selected
        
        [titleLabel, numberLabel].forEach {
            $0.textAlignment = .center
            $0.minimumScaleFactor = 0.5
            stack.addArrangedSubview($0)
        }
        return stack
    }
}

/// #Константы
extension NutrientsCell {
    private enum Nutrients: String {
        case calories = "Калории"
        case protein = "Белки"
        case fats = "Жиры"
        case carbohydrates = "Углеводы"
    }
}

