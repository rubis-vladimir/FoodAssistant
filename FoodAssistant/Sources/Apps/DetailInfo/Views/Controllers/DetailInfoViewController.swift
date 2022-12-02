//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

// Протокол управления View-слоем модуля DetailInfo
protocol DetailInfoViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

// Протокол делегата прокрутки экрана
protocol ScrollDelegate: AnyObject {
    // Отслеживает перемещение scrollView
    func scrollViewDidScroll(to offset: CGFloat)
}


// Контроллер представления детальной информации
final class DetailInfoViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: CGRect.zero,
                                        style: .grouped)
    private let presenter: DetailInfoPresentation
    private var factory: DIFactory?
    
    // MARK: - Init
    init(presenter: DetailInfoPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.contentInset.top = -(navigationController?.navigationBar.frame.maxY ?? UIApplication.shared.statusBarFrame.height)
    }
    
    // MARK: - Private func
    private func setupNavigationBar() {
        let faivoriteRightButton = createCustomBarButton(
            icon: .heartLargeFill, 
            selector: #selector(changeFaivoriteButtonTapped)
        )
        
        let backLeftButton = createCustomBarButton(
            icon: .leftFill,
            selector: #selector(backButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [faivoriteRightButton]
        navigationItem.leftBarButtonItems = [backLeftButton]
        
//        navigationController?.navigationBar.backgroundColor = .blue
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let model = presenter.model
        factory = DIFactory(tableView: tableView,
                            delegate: presenter,
                            scrollDelegate: self,
                            model: model)
        factory?.setupTableView()
    }
    
    private func setupConstraints() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    /// Добавляет/убирает рецепт к любимым рецептам
    @objc private func changeFaivoriteButtonTapped() {
        print("changeFaivoriteButtonTapped")
    }
    
    /// Возврат к корневому экрану
    @objc private func backButtonTapped() {
        /// Убираем прозрачность navBar
        ///
//        guard let tabBar = tabBarController else { return }
//        print(navigationController?.navigationBar.isTranslucent)
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.popViewController(animated: true)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "белый фон"), for: UIBarMetrics.default)
//        navigationController?.navigationBar.barTintColor = .white
//        navigationController?.navigationBar.tintColor = .white
        
        
//        navigationController
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "белый фон")?.alpha(1000), for: UIBarMetrics.default)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - DetailInfoViewable
extension DetailInfoViewController: DetailInfoViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}

// MARK: - ScrollDelegate
extension DetailInfoViewController: ScrollDelegate {
    func scrollViewDidScroll(to offset: CGFloat) {
        let alpha = offset * 0.005
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "белый фон")?.alpha(alpha), for: UIBarMetrics.default)
    }
}
