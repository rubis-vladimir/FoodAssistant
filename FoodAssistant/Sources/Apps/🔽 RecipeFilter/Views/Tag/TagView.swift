////
////  TagView.swift
////  FoodAssistant
////
////  Created by Владимир Рубис on 26.12.2022.
////
//
//import UIKit
//
//protocol Tapable: AnyObject {
//    
//    func didTapView(_ flag: Bool)
//}
//
//class TagView: UIView {
//    
//    weak var delegate: Tapable?
//    
//    private let singleTapGestureRecognizer = UITapGestureRecognizer()
//    
//    private var isSelected: Bool = false {
//        didSet {
//            if isSelected {
//                backgroundColor = Palette.darkColor.color
//            } else {
//                backgroundColor = Palette.bgColor.color
//            }
//        }
//    }
//    
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = Fonts.main
//        label.textAlignment = .center
//        label.tintColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCell()
//        setupGestureRecognizers()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with title: String) {
//        titleLabel.text = title
//    }
//    
//    private func setupCell() {
//        
//    }
//    
//    /// Настройка отработки касаний экрана
//    private func setupGestureRecognizers() {
//        singleTapGestureRecognizer.addTarget(self, action: #selector(handleSingleTapGesture(_:)))
//        singleTapGestureRecognizer.numberOfTapsRequired = 1
//        
//        singleTapGestureRecognizer.delegate = self
//        
//        self.addGestureRecognizer(singleTapGestureRecognizer)
//    }
//
//    private func setupConstraints() {
//        addSubview(titleLabel)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
//        ])
//    }
//    
//    @objc private func handleSingleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
//        isSelected.toggle()
//        delegate?.didTapView(isSelected)
//    }
//}
//
//// MARK: - UIGestureRecognizerDelegate
//extension TagView: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return gestureRecognizer === singleTapGestureRecognizer
//    }
//}
