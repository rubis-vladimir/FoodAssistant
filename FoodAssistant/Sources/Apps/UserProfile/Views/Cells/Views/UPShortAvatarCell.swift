//
//  UPShortAvatarCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

final class UPShortAvatarCell: UITableViewCell {
    
    weak var delegate: UserProfilePresentation?
    
    lazy var userContainer: UIView = {
        var view = UIView()
        view.backgroundColor = Palette.darkColor.color
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        setupConstraints()
    }
    
    func setupConstraints() {
        
        addSubview(userContainer)
        
        NSLayoutConstraint.activate([
            userContainer.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            userContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            userContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
