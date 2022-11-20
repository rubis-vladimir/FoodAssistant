//
//  UPAvatarCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

final class UPAvatarCell: UITableViewCell {
    
    weak var delegate: UserProfilePresentation?
    
    lazy var userContainer: UIView = {
        var view = UIView()
        view.backgroundColor = Palette.bgColor.color
        view.layer.addShadow(color: Palette.shadowColor.color)
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stack = UIStackView()
    let parametersStack = UIStackView()
    
    lazy var fullnameLabel: UILabel = {
        var label = UILabel()
        label.text = "Рубис Владимир"
        label.numberOfLines = 0
        label.font = label.font.withSize(30)
        label.textAlignment = .center
        return label
    }()
    
    lazy var detailButton: UIButton = {
        var button = UIButton()
        button.setTitle("Подробнее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var avatarView: UIImageView = {
        var view = UIImageView()
        view.backgroundColor = .white
        view.layer.addShadow(color: Palette.shadowColor.color)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        backgroundColor = .clear
        setupConstraints()
        setup()
    }
    
    func setup() {
        let parameterLabels = ["Возраст", "Рост", "Вес"]
        let valueLabels = ["30", "172", "75"]
        
        for index in 0..<parameterLabels.count {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 5
            stack.alignment = .center
            
            let valueLabel = UILabel()
            valueLabel.text = valueLabels[index]
            valueLabel.font = valueLabel.font.withSize(30)
            
            let parameterLabel = UILabel()
            parameterLabel.text = parameterLabels[index]
            
            stack.addArrangedSubview(valueLabel)
            stack.addArrangedSubview(parameterLabel)
            parametersStack.addArrangedSubview(stack)
        }
    }
    
    func setupConstraints() {
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.addArrangedSubview(avatarView)
        stack.addArrangedSubview(fullnameLabel)
        
//
//        stack.topAnchor.constraint(equalTo: userContainer.topAnchor, constant: 5).isActive = true
//        stack.centerXAnchor.constraint(equalTo: userContainer.centerXAnchor).isActive = true
//        stack.leadingAnchor.constraint(equalTo: userContainer.leadingAnchor, constant: 20).isActive = true
//        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        parametersStack.spacing = 20
        parametersStack.distribution = .fillEqually
        parametersStack.translatesAutoresizingMaskIntoConstraints = false
        
        userContainer.addSubview(parametersStack)
        userContainer.addSubview(stack)
        addSubview(userContainer)
        
        avatarView.layer.cornerRadius = 50

        parametersStack.bottomAnchor.constraint(equalTo: userContainer.bottomAnchor, constant: -20).isActive = true
        parametersStack.centerXAnchor.constraint(equalTo: userContainer.centerXAnchor).isActive = true
        parametersStack.leadingAnchor.constraint(equalTo: userContainer.leadingAnchor, constant: 20).isActive = true
        
        stack.topAnchor.constraint(equalTo: userContainer.topAnchor, constant: 20).isActive = true
        stack.leadingAnchor.constraint(equalTo: userContainer.leadingAnchor, constant: 20).isActive = true
        stack.centerXAnchor.constraint(equalTo: userContainer.centerXAnchor).isActive = true
        
        avatarView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 130).isActive = true
//
        userContainer.pinEdges(to: self, constant: 20)
    }
}
