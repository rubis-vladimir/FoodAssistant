//
//  BaseInfoCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

final class BaseInfoCell: UITableViewCell {
    
    private lazy var recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .orange
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "homeBackgroundImage")
        return iv
    }()
    
    private lazy var detailTitleView: DetailTitleView = {
        let view = DetailTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .orange
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Recipe) {
        detailTitleView.titleRecipeLabel.text = model.title
        detailTitleView.cookingTimeLabel.text = "\(model.readyInMinutes) мин"
        detailTitleView.numberServingsLabel.text = "\(model.servings) Порций"
    }
    
    func updateImage(with imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        recipeImageView.image = image
    }
    
    private func setupConstraints() {
        addSubview(recipeImageView)
        addSubview(detailTitleView)
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 400),
            
            detailTitleView.centerYAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            detailTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}