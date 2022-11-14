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
        let image = UIImage(named: "basket")?.withRenderingMode(.alwaysTemplate)
        b.setImage(image, for: .normal)
        b.imageView?.tintColor = .white
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
    }
    
    func setUpTabBar() {
        
        // tab bar layer
        let x: CGFloat = 20
        let y: CGFloat = 20
        let width = self.tabBar.bounds.width - x * 2
        let height = self.tabBar.bounds.height + y * 1.5
        layerHeight = height
        layer.fillColor = #colorLiteral(red: 0.8609796166, green: 0.8864883184, blue: 0.791760385, alpha: 1).cgColor
        layer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                      y: self.tabBar.bounds.minY - y,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height / 2).cgPath
        
        // tab bar shadow
        layer.shadowColor = #colorLiteral(red: 0.01498480421, green: 0.1761765778, blue: 0.04584238678, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        
        // add tab bar layer
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
        // fix items positioning
        self.tabBar.itemWidth = width / 6
        self.tabBar.itemPositioning = .centered
        self.tabBar.tintColor = #colorLiteral(red: 0.6, green: 0.1921568627, blue: 0.07843137255, alpha: 1)
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.650909543, green: 0.4934213161, blue: 0.4851912856, alpha: 1)
        
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
        middleButton.backgroundColor = #colorLiteral(red: 0.6, green: 0.1921568627, blue: 0.07843137255, alpha: 1)
        
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
        middleButton.layer.shadowColor = #colorLiteral(red: 0.01498480421, green: 0.1761765778, blue: 0.04584238678, alpha: 1).cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        middleButton.layer.shadowOpacity = 0.65
        middleButton.layer.shadowRadius = 8
        
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
}

// MARK: - MainTabBarViewable
extension MainTabBarController: MainTabBarViewable {
    
}
