//
//  UPFridgeCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

final class UPFridgeCell: UITableViewCell {
    
    weak var delegate: UserProfilePresentation?
    
    lazy var checkButton: UIButton = {
        var button = UIButton()
        button.setTitle("TEST", for: .normal)
        button.addTarget(self, action: #selector(testMethod), for: .touchUpInside)
        button.backgroundColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            
            checkButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 100),
            checkButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func testMethod() {
        print("TEST")
        delegate?.showTag()
    }
}

