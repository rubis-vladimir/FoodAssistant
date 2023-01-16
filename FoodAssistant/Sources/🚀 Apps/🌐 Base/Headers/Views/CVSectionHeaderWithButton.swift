//
//  MainSectionHeader.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.11.2022.
//

import UIKit

/// #Кастомный хедер для коллекции с кнопкой
final class CVSectionHeaderWithButton: CVBaseSectionHeader {
    
    // MARK: - Properties
    /// Действие
    private var action: ((Int) -> Void)?
    /// Первый вариант изображения
    private var firstImage: UIImage?
    /// Второй вариант изображения
    private var secondImage: UIImage?
    /// Номер секции
    private var section: Int?
    
    /// Флаг изменения изображения кнопки
    private var isFirst: Bool = true {
        didSet {
            let image = isFirst ? firstImage : secondImage
            headerButton.setImage(image,
                                  for: .normal)
        }
    }
    
    /// Кнопка в заголовке
    private lazy var headerButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.addTarget(self,
                         action: #selector(changeLayoutButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Контейнер для элементов
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Functions
    override func setupConstraints() {
        addSubview(container)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(headerButton)
        
        let padding = AppConstants.padding
        let widthButton: CGFloat = 30
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            container.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -padding),
            container.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            
            headerButton.widthAnchor.constraint(equalToConstant: widthButton)
        ])
    }
    
    /// Настраивает содержимое заголовка
    func configure(model: HeaderSectionModel,
                   section: Int?) {
        configure(title: model.title)
        
        self.firstImage = model.firstImage
        self.secondImage = model.secondImage
        self.action = model.action
        self.section = section
        
        if let image = firstImage {
            headerButton.setImage(image,
                                  for: .normal)
        }
    }
    
    /// Нажали на кнопку
    @objc private func changeLayoutButtonTapped() {
        if firstImage != nil,
           secondImage != nil {
            isFirst.toggle()
        }
        
        guard let action = action,
              let section = section else { return }
        action(section)
    }
}
