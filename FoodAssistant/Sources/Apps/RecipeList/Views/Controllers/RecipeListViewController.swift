//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем модуля RecipeList
protocol RecipeListViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// Контроллер представления списка рецептов
final class RecipeListViewController: UIViewController {

    private let presenter: RecipeListPresentation
    
    init(presenter: RecipeListPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.navigationController?.navigationBar.isHidden = false
//        presenter.testTranslate()
//        presenter.testGetRandom()
//        presenter.testGetRecipe()
    }
}

// MARK: - RecipeListViewable
extension RecipeListViewController: RecipeListViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}
