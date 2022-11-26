//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем
protocol DetailInfoViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// Контроллер представления
final class DetailInfoViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        view.layer.masksToBounds = true
//        view.scrollsToTop = true
//
//        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .orange
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "homeBackgroundImage")
        return iv
    }()
    
    private lazy var detailTitleView: DetailTitleView = {
        let view = DetailTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailNutrientsView: DetailNutrientsView = {
        let view = DetailNutrientsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let presenter: DetailInfoPresentation
    
    init(presenter: DetailInfoPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .orange
        
//        navigationController?.navigationBar.backgroundColor = .none
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        self.navigationController?.navigationBar.tintColor = .clear
//        self.navigationController?.navigationBar.barTintColor = .black
        
    }
    
//    private func setupNavBar() {
//            let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.configureWithOpaqueBackground()
//            navigationBarAppearance.backgroundColor = .clear
//        
//            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupConstraints()
    }
    
    
    func setupNavigationBar() {
        
        let faivoriteRightButton = createCustomBarButton(
            imageName: "heartLarge.fill",
            selector: #selector(changeFaivoriteButtonTapped)
        )
        let backLeftButton = createCustomBarButton(
            imageName: "left.fill",
            selector: #selector(backButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [faivoriteRightButton]
        navigationItem.leftBarButtonItems = [backLeftButton]
    }
    
    @objc func changeFaivoriteButtonTapped() {
        print("changeFaivoriteButtonTapped")
    }
    
    @objc func backButtonTapped() {
        print("backButtonTapped")
    }
    
    func setupConstraints() {
        
        let nutrient = Nutrient(name: "Calories",
                                amount: 125,
                                unit: "кал")
        let nutrient2 = Nutrient(name: "Protein",
                                amount: 10.5,
                                unit: "g")
        let nutrient3 = Nutrient(name: "Fat",
                                amount: 7.3,
                                unit: "g")
        let nutrient4 = Nutrient(name: "Carbohydrates",
                                amount: 18.25,
                                unit: "g")
        let nutrition = Nutrition(nutrients: [nutrient, nutrient2, nutrient3, nutrient4])
        detailNutrientsView.configure(with: nutrition)
        
//        let containerView = UIView()
//
//        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        scrollView.addSubview(detailTitleView)
        scrollView.addSubview(detailNutrientsView)
        
//        scrollView.contentSize = CGSizeMake(view.frame.size.width, 3000)
        
//        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 400),
        
            detailTitleView.centerYAnchor.constraint(equalTo: imageView.bottomAnchor),
            detailTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            detailNutrientsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailNutrientsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            detailNutrientsView.topAnchor.constraint(equalTo: detailTitleView.bottomAnchor, constant: 100),
            detailNutrientsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
}

// MARK: - Viewable
extension DetailInfoViewController: DetailInfoViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}
