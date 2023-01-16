//
//  InstructionCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 28.11.2022.
//

import UIKit

/// #Протокол передачи UI-ивента нажатия на кнопку таймера
protocol TimerTapable: AnyObject {
    
    /// Нажата кнопка таймера
    /// - Parameter step: Шаг в инструкции
    func didTapTimerButton(step: Int)
}

/// #Ячейка с инструкцией по приготовлению
final class InstructionCell: TVBaseCell {
    
    weak var delegate: TimerTapable?
    
    private var step: Int?
    
    private lazy var stepNumberLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cookingInstructionsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.main
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(Icons.alarm.image, for: .normal)
        
        button.tintColor = Palette.darkColor.color
        return button
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        return stack
    }()
    
    override func setupCell() {
        timerButton.addTarget(self,
                              action: #selector(didTapTimerButton),
                              for: .touchUpInside)
        
        stack.addArrangedSubview(stepNumberLabel)
        stack.addArrangedSubview(timerButton)
        [stack, cookingInstructionsLabel].forEach {
            container.addArrangedSubview($0)
        }
        
        contentView.addSubview(container)
        setupConstraints()
    }
    
    func configure(with step: InstructionStepProtocol) {
        let stepText = "Step".localize()
        stepNumberLabel.text = "\(stepText) \(step.number)"
        cookingInstructionsLabel.text = step.step
        self.step = step.number
        
        timerButton.isHidden = !isTime(from: step.step)
        
        container.layoutSubviews()
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    /// Проверяет есть ли время в тексте
    /// - Parameter text: текст
    private func isTime(from text: String) -> Bool {
        return text.contains("minut".localize()) || text.contains("hour".localize()) ? true : false
    }
    
    @objc private func didTapTimerButton() {
        guard let step = step else { return }
        delegate?.didTapTimerButton(step: step)
    }
}
