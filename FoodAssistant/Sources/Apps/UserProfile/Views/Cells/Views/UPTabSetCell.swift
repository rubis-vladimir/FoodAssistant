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
    
    private lazy var customTagButton1: UPCustomTagButtonView = {
        var button = UPCustomTagButtonView()
        
        button.setup(selector: #selector(testMethod), image: UIImage(named: "house")!, text: "TEST1")
        
        return button
    }()
    
    private lazy var customTagButton2: UPCustomTagButtonView = {
        var button = UPCustomTagButtonView()
        
        button.setup(selector: #selector(testMethod), image: UIImage(named: "basket")!, text: "TEST2")
        
        return button
    }()
    
    private var stack = UIStackView()
    
    private var customView = UPCustomSegmentedControl()
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupTest()
    }
    
    func setupTest() {
    
//        let customView = UPCustomSegmentedControl(buttonTitles: buttonTitles)
//        customView.buttonTitles = buttonTitles
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customView)
        customView.layer.cornerRadius = customView.frame.height / 2
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            customView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            customView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            customView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
    }
    
    func setupConstraints() {
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(customTagButton1)
        stack.addArrangedSubview(customTagButton2)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func testMethod() {
        print("TEST")
        delegate?.showTag()
    }
}
