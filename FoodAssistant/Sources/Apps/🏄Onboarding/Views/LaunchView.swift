//
//  LaunchView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.12.2022.
//

import UIKit

/// #Протокол делагата LaunchView
protocol LaunchViewDelegate: AnyObject {
    /// Ивент нажатия на кнопку готовности
    ///  - Parameter page: страница
    func didTapReadyButton(page: LaunchPage)
}

/// #Вью для онбординга
class LaunchView: UIView {
    
    // MARK: - Properties
    weak var delegate: LaunchViewDelegate?
    
    /// Вариант страницы
    private var page: LaunchPage?
    
    /// Вью фона в виде картинки
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode  = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Контейнер для текстовой информации
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.55)
        view.layer.cornerRadius = AppConstants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Лейбл заголовка
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.header
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Лейбл описания
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Fonts.selected
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Кнопка готовности
//    private let readyButton: UIButton = {
//        let button = UIButton()
//        button.titleLabel?.font = Fonts.header
//        button.backgroundColor = Palette.darkColor.color
//        button.layer.add(shadow: AppConstants.Shadow.defaultOne)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private lazy var readyButton = BaseRedButton(title: nil,
                                                 image: nil) { [weak self] in
        guard let page = self?.page else { return }
        self?.delegate?.didTapReadyButton(page: page)
    }
    
    // MARK: - Init & Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        readyButton.layer.cornerRadius = readyButton.frame.height / 2
    }
    
    // MARK: - Private func
    /// Обновляет данны во вью
    ///  - Parameter page: вариант страницы
    func updateView(page: LaunchPage?) {
        guard let page = page else { return }
        self.page = page
        
        switch page {
        case .last:
            let title = Constants.startTitle
            print(title)
            readyButton.setTitle(Constants.startTitle.localize(), for: .normal)
        default:
            let title = Constants.nextTitle
            print(title)
            readyButton.setTitle(Constants.nextTitle.localize(), for: .normal)
        }
        
        backgroundImageView.image = UIImage(named: page.rawValue)
        headerLabel.text = page.headerText
        descriptionLabel.text = page.descriptionText
    }
    
    private func setupView() {
        readyButton.addTarget(self, action: #selector(didTapReadyButton(_:)), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        containerView.addSubview(headerLabel)
        containerView.addSubview(descriptionLabel)
        
        addSubview(backgroundImageView)
        addSubview(containerView)
        addSubview(readyButton)
        
        let padding = AppConstants.padding
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: padding),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            
            readyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            readyButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2),
            readyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            readyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// Нажата кнопка готовности
    @objc private func didTapReadyButton(_ button: UIButton) {
        guard let page = page else { return }
        delegate?.didTapReadyButton(page: page)
    }
}

// MARK: - Constants
extension LaunchView {
    private struct Constants {
        static let startTitle = "Start".localize()
        static let nextTitle = "Next".localize()
    }
}
