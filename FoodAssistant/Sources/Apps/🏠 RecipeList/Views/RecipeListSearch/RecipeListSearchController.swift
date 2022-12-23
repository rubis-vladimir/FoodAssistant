//
//  RecipeListSearchController.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 23.12.2022.
//

import UIKit

final class RecipeListSearchController: UISearchController, UISearchBarDelegate {

    private let customSearchBar = RecipesSearchBar()
    
    override var searchBar: RecipesSearchBar {
        return customSearchBar
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
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
