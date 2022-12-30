//
//  BaseRedButton.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.12.2022.
//

import UIKit

/// #Базовая красная кнопка =D
class BaseRedButton: UIButton {
    /// Действие
    private var action: (() -> ())?
    
    /// Доп инициализатор
    /// - Parameters:
    ///  - title: текст кнопки
    ///  - image: изображение кнопки
    ///  - action: действие
    convenience init(title: String?,
                     image: UIImage?,
                     action: (() -> ())?) {
        self.init()
        
        self.action = action
        setupButton(title: title,
                    image: image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    /// Настройка кнопки
    private func setupButton(title: String?,
                             image: UIImage?) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        
        addTarget(self,
                  action: #selector(didTapButton),
                  for: .touchUpInside)
        
        titleLabel?.font = Fonts.subtitle
        tintColor = .white
        backgroundColor = Palette.darkColor.color
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func didTapButton() {
        guard let action = action else { return }
        action()
    }
}
