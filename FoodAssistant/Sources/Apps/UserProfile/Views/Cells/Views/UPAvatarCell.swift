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
        view.backgroundColor = Palette.darkColor.color
        view.layer.addShadow()
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avatarView: UIView = {
        var view = UIView()
        view.backgroundColor = Palette.bgColor.color
        view.layer.addShadow()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        addSubview(userContainer)
        userContainer.addSubview(avatarView)
        
        avatarView.layer.cornerRadius = 50
        
        avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        avatarView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
        userContainer.pinEdges(to: self)
    }
}
