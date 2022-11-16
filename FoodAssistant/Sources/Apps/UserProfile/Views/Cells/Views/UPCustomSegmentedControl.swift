//
//  UPCustomSegmentedControl: UIView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 16.11.2022.
//

import UIKit

class UPCustomSegmentedControl: UIView {
    
    var delegate: UPSegmentedViewDelegate?
    
    private lazy var buttonImages:[UIImage?] = ["card", "fridge", "heart"].map {
        UIImage(named: $0)?.withRenderingMode(.alwaysTemplate)
    }
    private lazy var buttonSelectImages:[UIImage?] = ["card.fill", "fridge.fill", "heart.fill"].map {
        UIImage(named: $0)?.withRenderingMode(.alwaysTemplate)
    }
    
    struct Constants {
        static let bgColor = Palette.bgColor.color
        static let selectorColor = Palette.darkColor.color
        static let textColor = UIColor.black
        static let selectorTextColor = UIColor.white
    }
    
    var buttons = [UIButton]()
    var buttonTitles: [String] = ["Main", "Fridge", "Favourite"]{
        didSet {
            updateView()
        }
    }
    
    var buttonImageNames: [String] = ["house", "basket", "house.fill"]
    
    var sv = UIStackView()
    
    private var currentIndex: Int = 0
    
    lazy var slideView: UIView = {
        var view = UIView(frame: CGRect.zero)
        view.backgroundColor = Constants.selectorColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        setupFirstSelection(index: currentIndex)
    }
    
    func setupView() {
        self.layer.addShadow()
        backgroundColor = Constants.bgColor
        updateView()
    }
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        for index in 0..<buttonTitles.count {
            let button = UIButton()
            let image = index == currentIndex ? buttonSelectImages[index] : buttonImages[index]
            let color = index == currentIndex ? UIColor.white : UIColor.black
            
            button.setTitle("", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tintColor = color
            button.setImage(image, for: .normal)
            button.addTarget(self,
                             action: #selector(buttonTapped),
                             for: .touchUpInside)
            button.imageEdgeInsets = index == currentIndex ? UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0) : button.imageEdgeInsets
            button.tag = index
            
            buttons.append(button)
        }
        
        buttons.forEach { sv.addArrangedSubview($0) }
        
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(slideView)
        addSubview(sv)
        
        sv.pinEdges(to: self)
    }
    
    func setupFirstSelection(index: Int) {
        let newButton = buttons[index]
        newButton.setTitle(buttonTitles[index], for: .normal)

        self.slideView.frame = newButton.frame
        self.slideView.layer.cornerRadius = self.slideView.frame.height / 2
        slideView.sizeToFit()
    }
    
    @objc func buttonTapped(sender: UIButton) {
        didSelectButton(at: sender.tag)
    }
    
    func didSelectButton(at index: Int) {
        //if self.currentIndex == index { return }
        self.delegate?.didSelectPage(index: index)
        
        let oldButton = buttons[currentIndex]
        //oldButton.backgroundColor = UIColor.clear
        
        let newButton = buttons[index]
        //newButton.backgroundColor = self.selectedBackgroundColor
        
        newButton.alpha = 0.0
        
        oldButton.setImage(buttonImages[currentIndex], for: .normal)
        oldButton.tintColor = .black
        oldButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        newButton.setImage(buttonSelectImages[index], for: .normal)
        newButton.tintColor = .white
        newButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        self.currentIndex = index
        UIView.animate(withDuration: 0.1) {
            oldButton.setTitle("", for: .normal)
            newButton.setTitle(self.buttonTitles[index], for: .normal)
            self.sv.layoutSubviews()
            self.layoutIfNeeded()
            newButton.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.slideView.frame = newButton.frame
            self.layoutIfNeeded()
        }, completion: nil)
        
        
        
        
    }
}


protocol UPSegmentedViewDelegate {
    func didSelectPage(index: Int)
}
