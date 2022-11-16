//
//  UserProfileViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем
protocol UserProfileViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
    
    func showTag()
}

/// Контроллер представления
final class UserProfileViewController: UITableViewController {
    
    /// Фабрика настройки табличного представления
    private var factory: TVFactoryProtocol?
    
//    lazy var userContainer: UIView = {
//        var view = UIView()
//        view.backgroundColor = Palette.darkColor.color
//        view.layer.addShadow()
//        view.layer.cornerRadius = 25
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    

    private let presenter: UserProfilePresentation
    
    init(presenter: UserProfilePresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        setupNavigationBar()
        
//        setupElements()
        factory = UPFactory(tableView: tableView,
                                     delegate: presenter,
                                     buildType: .start)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func setupElements() {
//        
//        view.addSubview(userContainer)
//        
//        NSLayoutConstraint.activate([
//            userContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            userContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
//            userContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            userContainer.heightAnchor.constraint(equalToConstant: 250)
//        ])
    }
    
    func setupNavigationBar() {
//        let saveRightButton = createCustomBarButton(
//            imageName: "xmark",
//            selector: #selector(saveAndExitRightButtonTapped)
//        )
        let cancelLeftButton = createCustomBarButton(
            imageName: "xmark",
            selector: #selector(cancelLeftButtonTapped)
        )
        
//        navigationItem.rightBarButtonItems = [saveRightButton]
        navigationItem.leftBarButtonItems = [cancelLeftButton]
    }
    
    /// Сохраняет событие и скрывает экран
    @objc private func saveAndExitRightButtonTapped() {
        
    }
    
    /// Скрывает экран
    @objc private func cancelLeftButtonTapped() {
        
    }
}

// MARK: - Viewable
extension UserProfileViewController: UserProfileViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
    
    func showTag() {
        factory = UPFactory(tableView: tableView,
                                     delegate: presenter,
                                     buildType: .tagFridge)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
