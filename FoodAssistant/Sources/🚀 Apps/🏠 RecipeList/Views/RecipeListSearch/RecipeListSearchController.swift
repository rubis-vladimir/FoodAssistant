//
//  RecipeListSearchController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.12.2022.
//

import UIKit

/// #Кастомный поисковой контроллер
final class RecipeListSearchController: UISearchController, UISearchBarDelegate {
    /// Кастомный `SearchBar`
    private let customSearchBar = RecipesSearchBar(isFilter: false)
    
    override var searchBar: RecipesSearchBar {
        return customSearchBar
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        /// Настройка
        searchBar.showsCancelButton = false
        obscuresBackgroundDuringPresentation = false
        customSearchBar.delegate = self
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//       
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UITextFieldDelegate
extension RecipeListSearchController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isActive = false
        return true
    }
}
