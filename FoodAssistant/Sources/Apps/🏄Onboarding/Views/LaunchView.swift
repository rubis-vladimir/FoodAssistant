//
//  LaunchView.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 19.12.2022.
//

import UIKit

protocol LaunchViewDelegate: AnyObject {
    
    func didTapReadyButton()
}

class LaunchView: UIView {
    weak var delegate: LaunchViewDelegate?
    
    let backgroundGradientCover: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.black.withAlphaComponent(0).cgColor
        let secondColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode  = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.55)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.55)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("I'm ready!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.backgroundColor = Palette.darkColor.color
        button.tintColor = .white
        
        button.layer.shadowColor = button.backgroundColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 3)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1
        button.layer.cornerRadius = 30
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityView: BallSpinFadeLoader = {
        let view = BallSpinFadeLoader()
//        view.frame = frame.inset(by: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageStack(for view: UIView) {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.distribution = .fillEqually
        
//        (0...0).forEach {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.image = UIImage(named: "image\(1)")
            stack.addArrangedSubview(imageView)
//        }
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    func setView() {
        backgroundImageView.layer.addSublayer(backgroundGradientCover)
        addSubview(backgroundImageView)
//        textFrameView.addSubview(titleTextLabel)
        textFrameView.addSubview(bodyTextLabel)
        addSubview(textFrameView)
        addSubview(readyButton)
        
        addImageStack(for: imageFrameView)
        addSubview(imageFrameView)
        
        
        readyButton.addTarget(self, action: #selector(didTapReadyButton(_:)), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        let padding = AppConstants.padding
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
//            titleTextLabel.leadingAnchor.constraint(equalTo: textFrameView.leadingAnchor, constant: padding),
//            titleTextLabel.trailingAnchor.constraint(equalTo: textFrameView.trailingAnchor, constant: -padding),
//            titleTextLabel.topAnchor.constraint(equalTo: textFrameView.topAnchor, constant: padding),
            
            bodyTextLabel.leadingAnchor.constraint(equalTo: textFrameView.leadingAnchor),
            bodyTextLabel.trailingAnchor.constraint(equalTo: textFrameView.trailingAnchor),
            bodyTextLabel.topAnchor.constraint(equalTo: textFrameView.topAnchor, constant: padding),
            
            textFrameView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            textFrameView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            textFrameView.heightAnchor.constraint(equalToConstant: 100),
            textFrameView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            textFrameView.bottomAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: padding),
            
            readyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            readyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            readyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            readyButton.heightAnchor.constraint(equalTo: readyButton.widthAnchor, multiplier: 1/6),
            
//            imageFrameView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageFrameView.topAnchor.constraint(equalTo: textFrameView.bottomAnchor, constant: padding * 2),
            imageFrameView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -padding * 2),
            imageFrameView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageFrameView.widthAnchor.constraint(equalTo: imageFrameView.heightAnchor, multiplier: 1 / 2)
        ])
    }
    
    @objc func didTapReadyButton(_ button: UIButton) {
        delegate?.didTapReadyButton()
    }
}
