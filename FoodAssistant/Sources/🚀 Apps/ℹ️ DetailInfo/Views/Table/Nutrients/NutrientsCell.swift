//
//  NutrientsCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Ячейка с информацией о питательных веществах
final class NutrientsCell: TVBaseCell {
    // MARK: - Properties
    private let container: UIStackView = {
       let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    convenience init(nutrients: [NutrientProtocol]) {
        self.init()
        configure(with: nutrients)
        container.backgroundColor = Palette.bgColor.color
        container.layer.add(shadow: AppConstants.Shadow.defaultOne)
        container.layer.cornerRadius = AppConstants.cornerRadius
    }
    
    // MARK: - Function
    func configure(with nutrients: [NutrientProtocol]) {
        
        if let calories = nutrients.first(where: {$0.name == Nutrients.calories.rawValue}) {
            let stack = createStack(title: Nutrients.calories.rawValue.localize(),
                                    number: "\(calories.amount)")
            container.addArrangedSubview(stack)
        }
        if let protein = nutrients.first(where: {$0.name == Nutrients.protein.rawValue}) {
            let stack = createStack(title: Nutrients.protein.rawValue.localize(),
                                    number: "\(protein.amount)")
            container.addArrangedSubview(stack)
        }
        if let fats = nutrients.first(where: {$0.name == Nutrients.fats.rawValue}) {
            let stack = createStack(title: Nutrients.fats.rawValue.localize(),
                                    number: "\(fats.amount)")
            container.addArrangedSubview(stack)
        }
        if let carbohydrates = nutrients.first(where: {$0.name == Nutrients.carbohydrates.rawValue}) {
            let stack = createStack(title: Nutrients.carbohydrates.rawValue.localize(),
                                    number: "\(carbohydrates.amount)")
            container.addArrangedSubview(stack)
        }
    }
    
    override func setupCell() {
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(container)
        
        let padding = AppConstants.padding
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: padding / 2),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding / 2),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
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
        case calories = "Calories"
        case protein = "Protein"
        case fats = "Fat"
        case carbohydrates = "Carbohydrates"
    }
}
