//
//  RecipeFilterViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Протокол передачи UI-ивентов слою презентации модуля RecipeFilter
protocol RecipeFilterPresentation {
    
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
    
    override func loadView() {
        view = filterView
    }
    private lazy var filterView = RecipeFilterView()
    
    init(presenter: RecipeFilterPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupConstraints()
        view.backgroundColor = .white
        navigationController?.navigationItem.titleView = navLabel
        navigationController?.navigationItem.hidesBackButton = true
    }
    
    func setupConstraints() {
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: 12)
        ])
    }
}

// MARK: - RecipreFilterViewable
extension RecipeFilterViewController: RecipeFilterViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}
