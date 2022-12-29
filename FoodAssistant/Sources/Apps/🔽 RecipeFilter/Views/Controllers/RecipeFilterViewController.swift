//
//  RecipeFilterViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit



/// #Протокол передачи UI-ивентов слою презентации модуля RecipeFilter
protocol RecipeFilterPresentation: CellTapable,
                                   RFSelectedIngredientsChangable,
                                   AnyObject {
    func checkFlag(indexPath: IndexPath) -> Bool
    
    func update(parameter: FilterParameter,
                text: String)
    
    func didTapShowResultButton()
}

/// #Контроллер представления фильтра рецептов
final class RecipeFilterViewController: UIViewController {

    private let presenter: RecipeFilterPresentation
    
    let navLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтр"
        label.font = Fonts.navTitle
        return label
    }()
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                         collectionViewLayout: getFlowLayout())
    private var factory: RFFactory?
    
    private lazy var showResultsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.subtitle
        button.backgroundColor = Palette.darkColor.color
        button.layer.add(shadow: AppConstants.Shadow.defaultOne)
        button.setTitle("Показать результаты", for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: RecipeFilterPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        navigationController?.navigationItem.titleView = navLabel
//        navigationController?.navigationItem.hidesBackButton = true
        
        showResultsButton.addTarget(self,
                                    action: #selector(didTapShowResultsButton),
                                    for: .touchUpInside)
        
        setupConstraints()
    }
    
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
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(showResultsButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo:  showResultsButton.topAnchor),
            
            showResultsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            showResultsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            showResultsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            showResultsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapShowResultsButton() {
        
//        navigationItem.searchController.
        presenter.didTapShowResultButton()

    }
}

// MARK: - RecipreFilterViewable
extension RecipeFilterViewController: RecipeFilterViewable {
    
    func update(section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }
    
    func updateCV(models: [FilterParameter : [TagModel]]) {
        DispatchQueue.main.async {
            self.factory = RFFactory(collectionView: self.collectionView,
                                     dictModels: models,
                                     delegate: self.presenter)
            self.factory?.setupCollectionView()
        }
    }
    
    func showTFAlert(parameter: FilterParameter, text: String) {
        showTFAlert(title: parameter.title,
                    text: text,
                    note: "Введите названия через\nзапятую и/или пробел") { [weak self] text in
            self?.presenter.update(parameter: parameter, text: text)
        }
    }
    
    func showError() {
        
    }
}
