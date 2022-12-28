//
//  CVTagCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.12.2022.
//

import UIKit

protocol CellTapable: AnyObject {
    
    func didTapElementCell(_ flag: Bool,
                           indexPath: IndexPath)
}

class CVTagCell: UICollectionViewCell {
    
    weak var delegate: CellTapable?
    
    private let singleTapGestureRecognizer = UITapGestureRecognizer()
    private var indexPath: IndexPath?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = Palette.darkColor.color
                titleLabel.textColor = .white
            } else {
                backgroundColor = Palette.bgColor.color
                titleLabel.textColor = .black
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.selected
        label.textAlignment = .center
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupGestureRecognizers()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(flag: Bool,
                   title: String,
                   indexPath: IndexPath,
                   height: CGFloat) {
        titleLabel.text = title
        self.indexPath = indexPath
        isSelected = flag
        clipsToBounds = true
        layer.cornerRadius = height / 2
    }
    
    private func setupCell() {
        singleTapGestureRecognizer.delegate = self
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = frame.size.height / 2
        layer.add(shadow: AppConstants.Shadow.defaultOne)
    }
    
    /// Настройка отработки касаний экрана
    private func setupGestureRecognizers() {
        singleTapGestureRecognizer.addTarget(self, action: #selector(handleSingleTapGesture(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func handleSingleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        isSelected.toggle()
        guard let indexPath = indexPath else { return }
        delegate?.didTapElementCell(isSelected, indexPath: indexPath)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CVTagCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === singleTapGestureRecognizer
    }
}
