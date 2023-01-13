//
//  UPAvatarCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

final class AvatarCell: UICollectionViewCell {
    
    weak var delegate: UserProfilePresentation?
    
    lazy var userContainer: UIView = {
        var view = UIView()
        view.backgroundColor = Palette.bgColor.color
        view.layer.add(shadow: AppConstants.Shadow.defaultOne)
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
        view.layer.add(shadow: AppConstants.Shadow.defaultOne)
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = Icons.myPhoto.image?.withRenderingMode(.alwaysOriginal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        let valueLabels = ["30", "172", "75"]
        
        for index in 0..<Constants.parameterLabels.count {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 5
            stack.alignment = .center
            
            let valueLabel = UILabel()
            valueLabel.text = valueLabels[index]
            valueLabel.font = valueLabel.font.withSize(30)
            
            let parameterLabel = UILabel()
            parameterLabel.text = Constants.parameterLabels[index]
            
            stack.addArrangedSubview(valueLabel)
            stack.addArrangedSubview(parameterLabel)
            parametersStack.addArrangedSubview(stack)
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.addArrangedSubview(avatarView)
        stack.addArrangedSubview(fullnameLabel)
        
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

        NSLayoutConstraint.activate([
            userContainer.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            userContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            userContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}

extension AvatarCell {
    struct Constants {
        static let parameterLabels = ["Age".localize(),
                                      "Height".localize(),
                                      "Weight".localize()]
    }
}
