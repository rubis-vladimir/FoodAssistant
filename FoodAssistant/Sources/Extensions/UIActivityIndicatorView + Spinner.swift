//
//  UIActivityIndicatorView + Spinner.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 03.12.2022.
//

import UIKit

extension UIActivityIndicatorView {
    
    /// Настраивает активити индикатор для `ImageView`
    func setupSpinner(loadingImageView: UIImageView) {
        let spinner = self
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: loadingImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loadingImageView.centerYAnchor).isActive = true
    }
}
