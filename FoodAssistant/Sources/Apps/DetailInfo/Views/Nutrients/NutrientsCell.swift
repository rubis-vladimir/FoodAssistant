//
//  NutrientsCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

final class NutrientsCell: CustomTableViewCell {
    
    private lazy var detailNutrientsView: DetailNutrientsView = {
        let view = DetailNutrientsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupCell() {
        setupConstraints()
    }
    
    func configure(with nutrition: Nutrition) {
        detailNutrientsView.configure(with: nutrition)
    }
    
    private func setupConstraints() {
        addSubview(detailNutrientsView)
        
        NSLayoutConstraint.activate([
            detailNutrientsView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            detailNutrientsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailNutrientsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailNutrientsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

