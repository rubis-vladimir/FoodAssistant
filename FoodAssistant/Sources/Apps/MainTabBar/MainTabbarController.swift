//
//  MainTabBarController.swift
//  LifeScreen
//
//  Created by Владимир Рубис on 19.07.2022.
//

import UIKit

/// Протокол управления View-слоем в модуле MainTabBar
protocol MainTabBarViewable: AnyObject {
    
}

/// Контроллер панели вкладок
final class MainTabBarController: UITabBarController {
    
    private let presenter: MainTabBarPresentation
    
    init(presenter: MainTabBarPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // tab bar layer
    var layer = CAShapeLayer()
    var layerHeight = CGFloat()
    
    var middleButton: UIButton = {
        let b = UIButton()
        b.setImage(Icons.basket.image,
                   for: .normal)
        b.imageView?.tintColor = .white
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
        setupNavigationBar()
    }
    
    func setUpTabBar() {
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        // tab bar layer
        let x: CGFloat = 16
        let y: CGFloat = 20
        let width = self.tabBar.bounds.width - x * 2
        let height = self.tabBar.bounds.height + y * 1.3
        layerHeight = height
        layer.fillColor = Palette.bgColor.color.cgColor
        layer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                      y: self.tabBar.bounds.minY - y,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height / 2).cgPath
        
        // tab bar shadow
        layer.shadowColor = Palette.shadowColor.color.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        
        // add tab bar layer
        tabBar.layer.insertSublayer(layer, at: 0)
        
        // fix items positioning
        tabBar.itemWidth = width / 6
        tabBar.itemPositioning = .centered
        tabBar.tintColor = Palette.darkColor.color
        tabBar.unselectedItemTintColor = Palette.lightColor.color
        
        // add middle button
        addMiddleButton()
        
    }
    
    /// Добавляем Среднюю кнопку и настраиваем ее
    func addMiddleButton() {
        
        /// Отключаем tabBarItem за пользовательской кнопкой middleButton
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                items[1].isEnabled = false
            }
        }
        
        //#colorLiteral(red: 0.1843137255, green: 0.3019607843, blue: 0.05490196078, alpha: 1)
        // #colorLiteral(red: 0.8885247111, green: 0.6562783122, blue: 0.01885649748, alpha: 1)
        tabBar.addSubview(middleButton)
        let size = CGFloat(50)
        let constant: CGFloat = -20 + ( layerHeight / 2 )
        middleButton.layer.cornerRadius = size / 2
        middleButton.backgroundColor = Palette.darkColor.color
        
        // set constraints
        let constraints = [
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: constant),
            middleButton.heightAnchor.constraint(equalToConstant: size),
            middleButton.widthAnchor.constraint(equalToConstant: size)
        ]
        
        for constraint in constraints {
            constraint.isActive = true
        }
        
        // shadow
        middleButton.layer.addShadow(color: Palette.shadowColor2.color,
                                     radius: 6,
                                     offsetHeight: 3)
        
        // other
        middleButton.layer.masksToBounds = false
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        
        // action
        middleButton.addTarget(self, action: #selector(routeToCreateEvent(sender:)), for: .touchUpInside)
    }
    
    /// Передача ивента навигации в Presenter
    @objc func routeToCreateEvent(sender: UIButton) {
        print("XXX")
        presenter.readyForRoute()
    }
    
    func setupNavigationBar() {
        let saveRightButton = createCustomBarButton(
            imageName: "xmark",
            selector: #selector(saveAndExitRightButtonTapped)
        )
        let cancelLeftButton = createCustomBarButton(
            imageName: "xmark",
            selector: #selector(cancelLeftButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [saveRightButton]
        navigationItem.leftBarButtonItems = [cancelLeftButton]
    }
    
    /// Сохраняет событие и скрывает экран
    @objc private func saveAndExitRightButtonTapped() {
        
    }
    
    /// Скрывает экран
    @objc private func cancelLeftButtonTapped() {
        
    }
}

// MARK: - MainTabBarViewable
extension MainTabBarController: MainTabBarViewable {
    
}
