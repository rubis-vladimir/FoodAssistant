//
//  RLSectionHeader.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.11.2022.
//

import UIKit

final class RLSectionHeader: UICollectionReusableView {
    
    weak var delegate: RLLayoutChangable?
    
    let titleLabel = UILabel()
    let changeLayoutButton = UIButton()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RLSectionHeader {
    
    func setupElements() {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = Fonts.subtitle
        titleLabel.textColor = .black
        
        changeLayoutButton.setImage(Icons.split2x2.image,
                                    for: .normal)
        changeLayoutButton.tintColor = .black
        changeLayoutButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(title: String,
                   isSelector: Bool) {
        titleLabel.text = title
        if isSelector {
            changeLayoutButton.addTarget(self,
                                         action: #selector(changeLayoutButtonTapped),
                                         for: .touchUpInside)
        } else {
            changeLayoutButton.isHidden = true
        }
    }
    
    func setupConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(changeLayoutButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            changeLayoutButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func changeLayoutButtonTapped() {
        delegate?.didTapChangeLayoutButton()
    }
}
