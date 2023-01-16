//
//  MainTabBarController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.07.2022.
//

import UIKit

/// #Контроллер панели вкладок
final class MainTabBarController: UITabBarController {
    // MARK: - Properties
    /// Слой для `TabBar`
    private var layer = CAShapeLayer()
    /// Высота для слоя
    private var layerHeight = CGFloat()
    
    /// Центральная кнопка
    private var middleButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.basket.image,
                   for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()
    
    private let presenter: MainTabBarPresentation
    
    // MARK: - Init & ViewDidLoad
    init(presenter: MainTabBarPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    // MARK: - Private func
    private func setupTabBar() {
        /// Делаем `TabBar` прозрачным
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        /// Настраиваем и добавляем слой для `TabBar`
        let width = self.tabBar.bounds.width - AppConstants.padding * 2
        let height = self.tabBar.bounds.height + AppConstants.padding * 1.2
        layerHeight = height
        
        layer.fillColor = Palette.bgColor.color.cgColor
        layer.path = UIBezierPath(roundedRect: CGRect(x: AppConstants.padding,
                                                      y: self.tabBar.bounds.minY - AppConstants.padding,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height / 2).cgPath
        layer.add(shadow: Constant.Shadow.one)
        
        tabBar.layer.insertSublayer(layer, at: 0)
        
        /// Настраиваем элементы `TabBar`
        tabBar.itemWidth = width / 6
        tabBar.itemPositioning = .centered
        tabBar.tintColor = Palette.darkColor.color
        tabBar.unselectedItemTintColor = Palette.lightColor.color
    
        addMiddleButton()
    }
    
    /// Добавляем Среднюю кнопку и настраиваем ее
    private func addMiddleButton() {
        let constant: CGFloat = layerHeight / 2 - AppConstants.padding
        
        /// Отключаем элемент TabBar за пользовательской кнопкой middleButton
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                items[1].isEnabled = false
            }
        }
        
        /// Настраиваем свойства
        middleButton.layer.cornerRadius = Constant.middleButtonSize / 2
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        middleButton.backgroundColor = Palette.darkColor.color
        middleButton.addTarget(self,
                               action: #selector(didMiddleButtonTapped),
                               for: .touchUpInside)
        
        middleButton.layer.add(shadow: Constant.Shadow.two)
        
        tabBar.addSubview(middleButton)
        
        /// Настраиваем констрейнты
        NSLayoutConstraint.activate([
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: constant),
            middleButton.heightAnchor.constraint(equalToConstant: Constant.middleButtonSize),
            middleButton.widthAnchor.constraint(equalToConstant: Constant.middleButtonSize)
        ])
    }
    
    /// Передача ивента навигации в Presenter
    @objc func didMiddleButtonTapped() {
        presenter.readyForRoute()
    }
}

// MARK: - Константы
extension MainTabBarController {
    private struct Constant {
        /// Размер кнопки
        static let middleButtonSize: CGFloat = 50
        
        /// Тени
        enum Shadow: ShadowProtocol {
            case one, two
            
            var color: UIColor { Palette.shadowColor.color }
            var radius: CGFloat {
                switch self {
                case .one: return 5.0
                case .two: return 6.0
                }
            }
            var opacity: Float {
                switch self {
                case .one: return 0.5
                case .two: return 0.65
                }
            }
            var offset: CGSize {
                switch self {
                case .one: return CGSize(width: 0.0, height: 1.0)
                case .two: return CGSize(width: 0.0, height: 3.0)
                }
            }
        }
    }
}
