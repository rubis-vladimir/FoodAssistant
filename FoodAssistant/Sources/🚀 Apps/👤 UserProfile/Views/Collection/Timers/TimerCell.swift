//
//  TimerCell.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 13.01.2023.
//

import UIKit

final class TimerCell: UICollectionViewCell {

    weak var delegate: UserProfilePresentation?

    private lazy var countLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.subtitle
        label.textAlignment = .center
        return label
    }()

    private lazy var recipeTitleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.selected?.withSize(22)
        label.textAlignment = .center
        return label
    }()

    private lazy var stepTitleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.selected
        label.textAlignment = .center
        return label
    }()

    private lazy var timerButton: UIButton = {
        var button = UIButton()
        button.setImage(Icons.alarm.image, for: .normal)
        button.tintColor = Palette.darkColor.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var substrate: UIView = {
        let view = UIView()
        view.layer.cornerRadius = AppConstants.cornerRadius
        view.layer.borderColor = Palette.darkColor.color.cgColor
        view.layer.borderWidth = 3
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with timer: RecipeTimer, index: Int) {

        recipeTitleLabel.text = "Timer".localize() + " \(index + 1)"
//        stepTitleLabel.text = timer.stepTimer.title
        countLabel.text = getTimeText(count: timer.count)

        timer.update = { [weak self] count in
            self?.countLabel.text = self?.getTimeText(count: count)
        }
    }

    func getTimeText(count: Int) -> String {
        let time = splitSeconds(count)
        return makeTimeString(hours: time.0,
                              minutes: time.1,
                              seconds: time.2)
    }

    /// Разделяет секунды на часы, минуты и секунды
    private func splitSeconds(_ seconds: Int) -> (Int, Int, Int) {
        let hours = seconds / 3600
        let minutes = (seconds - hours * 60) / 60

        return (hours, minutes, seconds % 60)
    }

    /// Создает строку времени для отображения
    private func makeTimeString(hours: Int,
                                minutes: Int,
                                seconds: Int) -> String {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func setupCell() {

        backgroundColor = Palette.bgColor.color
        layer.add(shadow: AppConstants.Shadow.defaultOne)
        layer.cornerRadius = AppConstants.cornerRadius

        timerButton.addTarget(self,
                              action: #selector(timerButtonTapped),
                              for: .touchUpInside)

        setupConstraints()
    }

    private func setupConstraints() {

        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.backgroundColor = .clear
        container.distribution = .fillEqually

        let stack = UIStackView()

        stack.addArrangedSubview(recipeTitleLabel)
        stack.addArrangedSubview(timerButton)
        stack.backgroundColor = .clear

        [stack, countLabel].forEach {
            container.addArrangedSubview($0)
        }

        addSubview(substrate)
        addSubview(container)

//        substrate.addSubview(countLabel)
//
//        addSubview(recipeTitleLabel)
//        addSubview(stepTitleLabel)
//        addSubview(substrate)
//        addSubview(timerButton)

        let padding = AppConstants.padding

        NSLayoutConstraint.activate([

            substrate.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1 / 2),
            substrate.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            substrate.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            substrate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            substrate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: padding / 2),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding / 2),

            timerButton.widthAnchor.constraint(equalTo: timerButton.heightAnchor)

//            substrate.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: padding / 2),
//            substrate.bottomAnchor.constraint(equalTo: stepTitleLabel.topAnchor, constant: -padding / 2),
//            substrate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding / 2),
//            substrate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding / 2),
//
//            recipeTitleLabel.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: padding / 2),
//            substrate.bottomAnchor.constraint(equalTo: stepTitleLabel.topAnchor, constant: -padding / 2),
//            substrate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding / 2),
//            substrate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding / 2),
        ])
    }

    @objc private func timerButtonTapped() {
        print("timerButtonTapped")
    }
}
