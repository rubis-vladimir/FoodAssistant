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
        view.layer.addShadow()
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        addSubview(userContainer)
        userContainer.pinEdges(to: self, constant: 20)
    }
}
