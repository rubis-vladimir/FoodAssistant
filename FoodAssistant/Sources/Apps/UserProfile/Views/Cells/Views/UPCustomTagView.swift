//
//  UPCustomTagButton.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

final class UPCustomTagButtonView: UIView {
    
    private lazy var customImageView: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.borderColor = Palette.darkColor.color.cgColor
        iv.layer.borderWidth = 2
        return iv
    }()
    
    private lazy var customLabel: UILabel = {
        var label = UILabel()
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 25
//        stack.addArrangedSubview(customImageView)
//        stack.addArrangedSubview(customLabel)
//        stack.addSubview(button)
        stack.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
//        addSubview(stack)
        
        
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: self.topAnchor),
//            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//        ])
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: self.topAnchor),
                    button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    button.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
    }
    
    
    func setup(selector: Selector, image: UIImage, text: String) {
        button.addTarget(self, action: selector, for: .touchUpInside)
        customImageView.image = image
        customLabel.text = text
    }
}

