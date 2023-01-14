//
//  CustomSegmentedControl.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 16.11.2022.
//

import UIKit

/// #Протокол управления UI-ивентами сегмент-вью
protocol SegmentedViewDelegate {
    /// Ивент при выборе элемента
    ///  - Parameter index: индекс элемента
    func didSelectSegment(index: Int)
}

/// #Кастомный сегмент-вью
class CustomSegmentedControl: UIView {
    
    // MARK: - Properties
    var delegate: SegmentedViewDelegate?
    /// Массив кнопок
    private var buttons = [UIButton]()
    /// Контейнер для кнопок
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    /// Текущий индекс
    private var currentIndex: Int = 1
    /// Вью показывающее выбранный сегмент
    private lazy var slideView: UIView = {
        var view = UIView(frame: CGRect.zero)
        view.backgroundColor = Constants.selectorColor
        return view
    }()
    
    // MARK: - Init & Override func
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        setupFirstSelection(index: currentIndex)
    }
    
    // MARK: - Private func
    func setupView() {
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        backgroundColor = Constants.bgColor
        
        /// Конфигурируем и добавляем кнопки
        for index in 0..<Constants.buttonTitles.count {
            let button = UIButton()
            
            let image = index == currentIndex ?
            Constants.buttonSelectImages[index] :
            Constants.buttonImages[index]
            
            let color = index == currentIndex ? UIColor.white : UIColor.black
            
            button.tintColor = color
            button.titleLabel?.font = Fonts.selected
            button.setImage(image, for: .normal)
            button.addTarget(self,
                             action: #selector(buttonTapped),
                             for: .touchUpInside)
            button.tag = index
            
            button.imageEdgeInsets = index == currentIndex ?
            AppConstants.edgeInsertImageButton :
            button.imageEdgeInsets
            
            buttons.append(button)
        }
        
        buttons.forEach { stack.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        addSubview(slideView)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    /// Настраивает первый выбранный сегмент
    /// - Parameter index: индекс сегмента
    private func setupFirstSelection(index: Int) {
        let newButton = buttons[index]
        newButton.setTitle(Constants.buttonTitles[index], for: .normal)

        slideView.frame = newButton.frame.insetBy(dx: 3, dy: 3)
        slideView.layer.cornerRadius = self.slideView.frame.height / 2
        slideView.sizeToFit()
    }
    
    /// Обновляет вью с учетом выбранного сегмента
    /// - Parameter index: индекс  сегмента
    private func didSelectButton(at index: Int) {
        /// Обновляем параметры кнопок
        let oldButton = buttons[currentIndex]
        let newButton = buttons[index]
        
        oldButton.setImage(Constants.buttonImages[currentIndex],
                           for: .normal)
        oldButton.tintColor = .black
        oldButton.imageEdgeInsets = UIEdgeInsets.zero
        
        newButton.setImage(Constants.buttonSelectImages[index],
                           for: .normal)
        newButton.tintColor = .white
        newButton.imageEdgeInsets = AppConstants.edgeInsertImageButton
        
        currentIndex = index
        newButton.alpha = 0.0
        
        /// Добавляем анимации
        UIView.animate(withDuration: 0.1) {
            oldButton.setTitle("", for: .normal)
            newButton.setTitle(Constants.buttonTitles[index],
                               for: .normal)
            self.stack.layoutSubviews()
            self.layoutIfNeeded()
            newButton.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [],
                       animations: {
            self.slideView.frame = newButton.frame
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// Ивент при нажатии на кнопку
    @objc private func buttonTapped(sender: UIButton) {
        didSelectButton(at: sender.tag)
        delegate?.didSelectSegment(index: sender.tag)
    }
}

// MARK: - Константы
extension CustomSegmentedControl {
    private struct Constants {
        static let bgColor = Palette.bgColor.color
        static let selectorColor = Palette.darkColor.color
        static let textColor = UIColor.black
        static let selectorTextColor = UIColor.white
        
        static let buttonImages: [UIImage?] = [Icons.personCard.image,
                                               Icons.fridge.image,
                                               Icons.heart.image]
        
        static let buttonSelectImages: [UIImage?] = [Icons.personCardFill.image,
                                                     Icons.fridgeFill.image,
                                                     Icons.heartFill.image]
        
        static let buttonTitles: [String] = ["Profile".localize(),
                                             "Fridge".localize(),
                                             "Recipes".localize()]
    }
}


