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
    private let customSearchBar = RecipesSearchBar()
    
    override var searchBar: RecipesSearchBar {
        return customSearchBar
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        /// Настройка
        searchBar.showsCancelButton = false
        obscuresBackgroundDuringPresentation = false
        customSearchBar.delegate = self
    }
    
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
