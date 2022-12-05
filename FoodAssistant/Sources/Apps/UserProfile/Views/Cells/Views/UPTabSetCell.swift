//
//  UPTabSetCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 15.11.2022.
//

import UIKit

final class UPTabSetCell: UITableViewCell {
    
    weak var delegate: UserProfilePresentation?
    
    lazy var checkButton: UIButton = {
        var button = UIButton()
        button.setTitle(" TEST", for: .normal)
        button.setImage(UIImage(named: "house"), for: .normal)
        button.addTarget(self, action: #selector(testMethod), for: .touchUpInside)
        button.backgroundColor = Palette.darkColor.color
//
//
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.clipsToBounds = true
        button.imageView?.layer.cornerRadius = button.bounds.height / 2
        button.imageView?.backgroundColor = Palette.lightColor.color
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
    
    private var stack = UIStackView()
    
    private var customView = UPCustomSegmentedControl()
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupTest()
    }
    
    func setupTest() {
    
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customView)
        customView.layer.cornerRadius = customView.frame.height / 2
        
        
        customView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        customView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        
    }
    
    func setupConstraints() {
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc func testMethod() {
        print("TEST")
        delegate?.showTag()
    }
}
