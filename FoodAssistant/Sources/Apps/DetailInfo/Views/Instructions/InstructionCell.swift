//
//  InstructionCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

final class InstructionCell: BaseTableViewCell {
    
    private lazy var stepNumberLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cookingInstructionsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func setupCell() {
        [stepNumberLabel, cookingInstructionsLabel].forEach {
            container.addArrangedSubview($0)
        }
        setupConstraints()
    }
    
    func configure(with step: InstuctionStep) {
        stepNumberLabel.text = "Шаг \(step.number)"
        cookingInstructionsLabel.text = step.step
        
        stepNumberLabel.sizeToFit()
        stepNumberLabel.layoutIfNeeded()
        cookingInstructionsLabel.sizeToFit()
        cookingInstructionsLabel.layoutIfNeeded()
        
        container.sizeToFit()
        container.layoutIfNeeded()
    }
    
    private func setupConstraints() {
        
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

