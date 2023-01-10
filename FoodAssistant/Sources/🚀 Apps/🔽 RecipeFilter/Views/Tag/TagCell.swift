//
//  TagCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 26.12.2022.
//

import UIKit

/// #Протокол передачи UI-ивента касания(тапа)
protocol CellTapable: AnyObject {
    /// Нажата ячейка
    /// - Parameters:
    ///  - flag: флаг выбора
    ///  - indexPath: индекс в коллекции
    func didTapElementCell(_ flag: Bool,
                           indexPath: IndexPath)
}

/// #Ячейка с тэгом
class TagCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: CellTapable?
    
    private let singleTapGestureRecognizer = UITapGestureRecognizer()
    private var indexPath: IndexPath?
    
    var isTap: Bool = false {
        didSet {
            if isTap {
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
    
    // MARK: - Init & Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupGestureRecognizers()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Function
    /// Конфигурирует ячейку
    /// - Parameters:
    ///  - flag: флаг выбора
    ///  - title: текст
    ///  - indexPath: индекс в коллекции
    func configure(flag: Bool,
                   title: String,
                   indexPath: IndexPath) {
        titleLabel.text = title
        self.indexPath = indexPath
        
        isTap = flag
    }
    
    private func setupCell() {
        singleTapGestureRecognizer.delegate = self
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
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
    
    /// Обработка одного касания
    @objc private func handleSingleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        isTap.toggle()
        guard let indexPath = indexPath else { return }
        delegate?.didTapElementCell(isTap,
                                    indexPath: indexPath)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TagCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === singleTapGestureRecognizer
    }
}
