//
//  CustomActivityIndicator.swift
//  FoodAssistant

//  Copyright (c) 2016 Vinh Nguyen

import UIKit

/// #Кастомный индикатор загрузки - Вращение мяча с затуханием
class BallSpinFadeLoader: UIView {

    /// Флаг работы анимации
    private var isAnimating: Bool = false
    var color: UIColor = Palette.darkColor.color

    override var bounds: CGRect {
        didSet {
            /// Настраиваем анимацию при изменении `bounds`
            if oldValue != bounds && isAnimating {
                setupAnimation()
            }
        }
    }

    /// Запускает анимацию загрузки
    func startAnimating() {
        guard !isAnimating else {
            return
        }
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation()
    }

    /// Останавливает анимацию загрузки
    func stopAnimating() {
        guard isAnimating else {
            return
        }
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }

    /// Настраивает активити индикатор для `ImageView`
    func setupSpinner(loadingImageView: UIImageView) {
        let spinner = self
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: loadingImageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: loadingImageView.centerYAnchor).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    /// Настраивает анимацию загрузки
    private func setupAnimation() {
        var animationRect = frame
        let minEdge = min(animationRect.width, animationRect.height)

        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        setupAnimationView(in: layer, size: animationRect.size, color: color)
    }

    /// Настройка анимационной вью
    ///  - Parameters:
    ///   - layer: слой
    ///   - size: размер
    ///   - color: цвет
    private func setupAnimationView(in layer: CALayer,
                                    size: CGSize,
                                    color: UIColor) {
        let circleSpacing: CGFloat = -2
        let circleSize = (size.width - 4 * circleSpacing) / 5
        let xPoint = (layer.bounds.size.width - size.width) / 2
        let yPoint = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84]

        /// Изменение размера анимированного объекта по времени
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")

        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration

        /// Изменение прозрачности анимированного объекта по времени
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")

        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration

        /// Добавление анимаций
        let animation = CAAnimationGroup()

        animation.animations = [scaleAnimation, opacityAnimaton]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        /// Рисуем круги и добавляем к ним анимацию
        for index in 0 ..< 8 {
            let circle = circleAt(angle: CGFloat(Double.pi / 4) * CGFloat(index),
                                  size: circleSize,
                                  origin: CGPoint(x: xPoint, y: yPoint),
                                  containerSize: size,
                                  color: color)

            animation.beginTime = beginTime + beginTimes[index]
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }

    /// Получает круг в указанной точке
    /// - Parameters:
    ///  - angle: угол
    ///  - size: размер
    ///  - origin: координата
    ///  - containerSize: размер контейнера анимации
    ///  - color: цвет
    /// - Returns: объект CA
    private func circleAt(angle: CGFloat,
                          size: CGFloat,
                          origin: CGPoint,
                          containerSize: CGSize,
                          color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - size / 2
        let circle = circleLayerWith(size: CGSize(width: size, height: size),
                                     color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: size,
            height: size)

        circle.frame = frame
        return circle
    }

    /// Получает круг
    ///  - Parameters:
    ///   - size: размер
    ///   - color: цвет
    ///  - Returns: объект CA
    private func circleLayerWith(size: CGSize,
                                 color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }
}
