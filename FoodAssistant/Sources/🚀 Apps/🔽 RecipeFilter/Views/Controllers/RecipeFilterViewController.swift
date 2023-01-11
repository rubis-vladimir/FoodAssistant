//
//  RecipeFilterViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации модуля RecipeFilter
protocol RecipeFilterPresentation: CellTapable,
                                   SelectedIngredientsChangable,
                                   SearchBarFilterDelegate,
                                   AnyObject {
    /// Ивент нажатия на изменение данных параметра
    /// - Parameters:
    ///  - parameter: параметр
    ///  - text: текст
    func didTapChange(parameter: FilterParameters,
                      text: String)
    /// Ивент нажатия на кнопку показать результаты
    func didTapShowResultButton()
    /// Проверка флага выбора
    func checkFlag(indexPath: IndexPath) -> Bool
}

/// #Контроллер представления фильтра рецептов
final class RecipeFilterViewController: UIViewController {

    // MARK: - Properties
    private let presenter: RecipeFilterPresentation
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                         collectionViewLayout: AppConstants.getFlowLayout())
    private var factory: RFFactory?
    
    /// Кнопка показать результаты
    private lazy var showResultsButton = BaseRedButton(title: Constants.showResultsButtonTitle,
                                                       image: nil) { [weak self] in
        self?.presenter.didTapShowResultButton()
    }
    
    private let searchBar = RecipesSearchBar(isFilter: true)
    
    // MARK: - Init & Override
    init(presenter: RecipeFilterPresentation) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        setupConstraints()
    }
    
    // MARK: - Private func
    private func setupElements() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.filterDelegate = presenter
        searchBar.delegate = self
        
        navigationItem.titleView = createNavTitle(title: "Filter".localize())
        navigationItem.hidesBackButton = true
    }
    
    private func setupConstraints() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(showResultsButton)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo:  showResultsButton.topAnchor),
            
            showResultsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            showResultsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            showResultsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.padding),
            showResultsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - UISearchBarDelegate
extension RecipeFilterViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        presenter.didTapShowResultButton()
    }
}


// MARK: - RecipreFilterViewable
extension RecipeFilterViewController: RecipeFilterViewable {
    func getSearchText() -> String? {
        searchBar.text
    }
    
    func updateSearch(text: String) {
        searchBar.text = text
    }
    
    func update(section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }
    
    func updateCV(dictModels: [FilterParameters : [TagModel]]) {
        DispatchQueue.main.async {
            self.factory = RFFactory(collectionView: self.collectionView,
                                     dictModels: dictModels,
                                     delegate: self.presenter)
        }
    }
    
    func showTFAlert(parameter: FilterParameters, text: String) {
        showTVAlert(title: parameter.title,
                    text: text,
                    note: Constants.noteText) { [weak self] text in
            self?.presenter.didTapChange(parameter: parameter, text: text)
        }
    }
}

// MARK: - Constants
extension RecipeFilterViewController {
    private struct Constants {
        static let showResultsButtonTitle = "Show results".localize()
        static let noteText = "Enter titles separated by commas".localize()
    }
}
