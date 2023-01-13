//
//  TimerCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.01.2023.
//

import UIKit

final class TimerCell: UICollectionViewCell {

    weak var delegate: UserProfilePresentation?
    
    let stack = UIStackView()
    
    lazy var countLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(30)
        label.textAlignment = .center
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(30)
        label.textAlignment = .center
        return label
    }()
    
    lazy var timerButton: UIButton = {
        var button = UIButton()
        button.setImage(Icons.alarm.image, for: .normal)
        button.tintColor = Palette.darkColor.color
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with timer: RecipeTimer) {
        
    }
    
    private func setupCell() {
        timerButton.addTarget(self,
                              action: #selector(timerButtonTapped),
                              for: .touchUpInside)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(countLabel)
        stack.addArrangedSubview(timerButton)
        
        let padding = AppConstants.padding
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    @objc private func timerButtonTapped() {
        
    }
}
