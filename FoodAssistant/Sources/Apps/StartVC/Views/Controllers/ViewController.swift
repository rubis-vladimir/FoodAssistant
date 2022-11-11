//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// Протокол управления View-слоем
protocol Viewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

/// Контроллер представления
final class ViewController: UIViewController {

    private let presenter: Presentation
    
    init(presenter: Presentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
//        presenter.testTranslate()
//        presenter.testGetRandom()
        presenter.testGetRecipe()
    }
}

// MARK: - Viewable
extension ViewController: Viewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}
