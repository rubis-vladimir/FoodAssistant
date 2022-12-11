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
    func updateUI(with type: UPBuildType)
    /// Показать ошибку
    func showError()
    
    func reloadSection(_ section: Int)
}

/// Контроллер представления
final class UserProfileViewController: UIViewController {
    
    /// Фабрика настройки табличного представления
    private var factory: CVFactoryProtocol?
    
    private var collectionView: UICollectionView!
    
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
        setupElements()
        
//        let models = presenter.viewModels
//        factory = UPFactory(collectionView: collectionView,
//                            delegate: presenter,
//                            buildType: .favorite(models))
        //        DispatchQueue.main.async {
        //            self.collectionView.reloadData()
        //        }
        factory = UPFactory(collectionView: collectionView,
                            delegate: presenter,
                            buildType: .profile)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.fetchRecipe()
    }
    
    func setupElements() {
        
        /// Настройка `CollectionView`
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: getFlowLayout())
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let titleView = UPCustomSegmentedControl()
        titleView.delegate = presenter
        
        
        view.addSubview(collectionView)
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleView.heightAnchor.constraint(equalToConstant: 42),
            
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
        ])
    }
    
    /// Возвращает настроенный `FlowLayout`
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding = AppConstants.padding
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        return layout
    }
    
    func setupNavigationBar() {
        let saveRightButton = createCustomBarButton(
            icon:.gearshape,
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
    func reloadSection(_ section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }
    
    func updateUI(with type: UPBuildType) {
        DispatchQueue.main.async {
            self.factory = UPFactory(collectionView: self.collectionView,
                                     delegate: self.presenter,
                                     buildType: type)
        }
    }
    
    
    func showError() {
        
    }
}
