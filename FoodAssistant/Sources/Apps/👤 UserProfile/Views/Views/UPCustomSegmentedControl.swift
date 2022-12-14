//
//  UPCustomSegmentedControl: UIView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 16.11.2022.
//

import UIKit

class UPCustomSegmentedControl: UIView {
    
    var delegate: SegmentedViewDelegate?
    
    private lazy var buttonImages: [UIImage?] = [Icons.card.image, Icons.fridge.image, Icons.heart.image]
    private lazy var buttonSelectImages: [UIImage?] = [Icons.cardFill.image, Icons.fridgeFill.image, Icons.heartFill.image]
    
    struct SelfConstants {
        static let bgColor = Palette.bgColor.color
        static let selectorColor = Palette.darkColor.color
        static let textColor = UIColor.black
        static let selectorTextColor = UIColor.white
    }
    
    var buttons = [UIButton]()
    var buttonTitles: [String] = ["Профиль", "Холодильник", "Рецепты"]

    var sv = UIStackView()
    
    private var currentIndex: Int = 0
    
    lazy var slideView: UIView = {
        var view = UIView(frame: CGRect.zero)
        view.backgroundColor = SelfConstants.selectorColor
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
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        backgroundColor = SelfConstants.bgColor
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
            button.imageEdgeInsets = index == currentIndex ? AppConstants.edgeInsert : button.imageEdgeInsets
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
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupFirstSelection(index: Int) {
        let newButton = buttons[index]
        newButton.setTitle(buttonTitles[index], for: .normal)

        self.slideView.frame = newButton.frame.insetBy(dx: 3, dy: 3)
        self.slideView.layer.cornerRadius = self.slideView.frame.height / 2
        slideView.sizeToFit()
    }
    
    @objc func buttonTapped(sender: UIButton) {
        didSelectButton(at: sender.tag)
        delegate?.didSelectSegment(index: sender.tag)
    }
    
    func didSelectButton(at index: Int) {
        self.delegate?.didSelectSegment(index: index)
        
        let oldButton = buttons[currentIndex]
        let newButton = buttons[index]
        
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


