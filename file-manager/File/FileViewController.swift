//
//  FileViewController.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FileViewController: BaseViewController {
    
    private enum Constant {
        static let fileImageViewHeightMultiplier = 0.4
        static let fileImageViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let titleLabelTopAnchor = 10.0
        
        static let alertActionTitle = "OK"
        
        static let fileImageName = "doc.richtext"
    }
    
    private lazy var fileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: Constant.fileImageName)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    private var viewModel: FileViewModelProvider
    
    init(viewModel: FileViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        commonInit()
        bind()
        viewModel.didLoad()
        configure()
    }
    
    private func bind() {
        
        viewModel.showErrorAlert = { title, message in
            self.showAlert(title: title, message: message)
        }
        
        viewModel.updateLoading = { isLoading in
            self.setLoading(isLoading)
        }
    }
    
    private func commonInit() {
        setupSubviews()
        setupAutoLayout()
    }
    
    private func setupSubviews() {
        view.addSubview(fileImageView)
        view.addSubview(titleLabel)
    }

    private func setupAutoLayout() {
        fileImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Constant.fileImageViewHeightMultiplier),
            fileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.fileImageViewInsets.top),
            fileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.fileImageViewInsets.left),
            fileImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.fileImageViewInsets.right),
            
            titleLabel.topAnchor.constraint(equalTo: fileImageView.bottomAnchor, constant: Constant.titleLabelTopAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: fileImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: fileImageView.trailingAnchor)
        ])
    }
    
    private func configure() {
        guard let title = viewModel.file?.title else { return }
        titleLabel.text = title
    }
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: Constant.alertActionTitle,
                                   style: .cancel)
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
