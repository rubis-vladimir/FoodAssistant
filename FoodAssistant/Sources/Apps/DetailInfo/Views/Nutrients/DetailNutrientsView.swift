//
//  DetailNutrientsView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.11.2022.
//

import UIKit

final class DetailNutrientsView: UIView {
    
    private var numberServingsLabel: [UILabel] = []
    
    private let container: UIStackView = {
       let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nutrientTitles: [String] = ["Калории", "Белки", "Жиры", "Углеводы"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Palette.bgColor.color
        layer.addShadow()
        layer.cornerRadius = 20
        
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with nutrition: Nutrition?) {
        
        if let calories = nutrition?.calories {
            let stack = createStack(title: "Калории", number: calories)
            container.addArrangedSubview(stack)
        }
        if let protein = nutrition?.protein {
            let stack = createStack(title: "Белки", number: protein)
            container.addArrangedSubview(stack)
        }
        if let fats = nutrition?.fats {
            let stack = createStack(title: "Жиры", number: fats)
            container.addArrangedSubview(stack)
        }
        if let carbohydrates = nutrition?.carbohydrates {
            let stack = createStack(title: "Углеводы", number: carbohydrates)
            container.addArrangedSubview(stack)
        }
        
        reloadInputViews()
    }
    
    
    func setupConstrains() {
        
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
    }
    
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


