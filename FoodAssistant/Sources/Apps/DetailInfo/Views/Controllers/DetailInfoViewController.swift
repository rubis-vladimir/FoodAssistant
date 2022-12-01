//
//  ViewController.swift
//  ModuleVIPER
//
//  Created by Владимир Рубис on 30.10.2022.
//

import UIKit

// Протокол управления View-слоем модуля DetailInfo
protocol DetailInfoViewable: AnyObject {
    /// Обновление UI
    func updateUI()
    /// Показать ошибку
    func showError()
}

// Контроллер представления детальной информации
final class DetailInfoViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: CGRect.zero,
                                        style: .grouped)
    private let presenter: DetailInfoPresentation
    private var factory: DIFactory?
    
    // MARK: - Init
    init(presenter: DetailInfoPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        tableView.contentInset.top = -(navigationController?.navigationBar.frame.maxY ?? UIApplication.shared.statusBarFrame.height)
        print("____________________")
        print(navigationController?.navigationBar.frame.minY)
        print(UIApplication.shared.statusBarFrame.height)
        print(navigationController?.navigationBar.frame.maxY)
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.contentInset.top = -(navigationController?.navigationBar.frame.maxY ?? UIApplication.shared.statusBarFrame.height)
    }
    
    // MARK: - Private func
    private func setupNavigationBar() {
        let faivoriteRightButton = createCustomBarButton(
            imageName: "heartLarge.fill",
            selector: #selector(changeFaivoriteButtonTapped)
        )
        
        let backLeftButton = createCustomBarButton(
            imageName: "left.fill",
            selector: #selector(backButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [faivoriteRightButton]
        navigationItem.leftBarButtonItems = [backLeftButton]
    }
    
    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let model = presenter.model
        factory = DIFactory(tableView: tableView,
                            delegate: presenter,
                            model: model)
        factory?.setupTableView()
    }
    
    private func setupConstraints() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func changeFaivoriteButtonTapped() {
        print("changeFaivoriteButtonTapped")
        guard let navigationController = navigationController else  {
            return
        }
        
        navigationController.navigationBar.setBackgroundImage(UIImage().alpha(1), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage().alpha(1)
        
    }
    
    @objc private func backButtonTapped() {
        print("backButtonTapped")
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - DetailInfoViewable
extension DetailInfoViewController: DetailInfoViewable {
    func updateUI() {
    
    }
    
    func showError() {
        
    }
}


extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
