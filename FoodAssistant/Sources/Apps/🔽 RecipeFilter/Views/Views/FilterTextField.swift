//
//  FilterTextField.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 24.12.2022.
//

import UIKit

class FilterTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
}
