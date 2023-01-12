//
//  LaunchViewController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

/// #Варианты страницы для модуля Launch
enum LaunchPage: String, CaseIterable {
    case first = "firstImage"
    case second = "secondImage"
    case third = "thirdImage"
    case last = "lastImage"
}

extension LaunchPage {
    /// Текст заголовка
    var headerText: String {
        switch self {
        case .first: return "Welcome to FoodAssistant!".localize()
        case .second: return "Find tasty and healthy".localize()
        case .third: return "Save Recipes".localize()
        case .last: return "Create Shop-list".localize()
        }
    }
    /// Текст описания
    var descriptionText: String {
        switch self {
        case .first: return "This application will help you prepare tasty and healthy food according to various recipes".localize()
        case .second: return "You can quickly 🔍 find hundreds of healthy and easy-to-cook recipes. And we'll show you what to cook with your ingredients".localize()
        case .third: return "You can add the recipes you like to ❤Favorites so that they are always at hand".localize()
        case .last: return "Choose dishes to cook, indicate which ingredients you will use from the available ones ✅ and get an up-to-date Shop List of the selected dishes".localize()
        }
    }
}

/// #Контроллер представления для PageVC модуля Launch
final class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var customView: LaunchView = {
        let view = LaunchView()
        view.updateView(page: page)
        return view
    }()
    
    weak var delegate: LaunchViewDelegate?
    private var page: LaunchPage?
    
    // MARK: - Init & Override
    init(page: LaunchPage?,
         delegate: LaunchViewDelegate?) {
        self.page = page
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.delegate = delegate
    }
}


