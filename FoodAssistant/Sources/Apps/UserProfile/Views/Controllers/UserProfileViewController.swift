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
final class UserProfileViewController: UIViewController {
    
    /// Фабрика настройки табличного представления
    private var factory: TVFactoryProtocol?
    
    private var tableView = UITableView()
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
        setupNavigationBar()
        
        
        
        factory = UPFactory(tableView: tableView,
                                     delegate: presenter,
                                     buildType: .start)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupElements()
    }
    
    func setupElements() {
        let titleView = UPCustomSegmentedControl()
        view.addSubview(titleView)
        view.addSubview(tableView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.heightAnchor.constraint(equalToConstant: 42),
            
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let saveRightButton = createCustomBarButton(
            imageName: "gearshape.fill",
            selector: #selector(saveAndExitRightButtonTapped)
        )
        
        navigationItem.title = "Мой помощник"
        navigationItem.rightBarButtonItems = [saveRightButton]
    }
    
    /// Сохраняет событие и скрывает экран
    @objc private func saveAndExitRightButtonTapped() {
        
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
