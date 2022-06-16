//
//  FileViewController.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FileViewController: UIViewController {
    
    private lazy var fileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "doc.richtext")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [fileImageView, titleLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
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
        viewModel.didLoad()
        configure()
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
            fileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            fileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            fileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            fileImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            titleLabel.topAnchor.constraint(equalTo: fileImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: fileImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: fileImageView.trailingAnchor),

        ])
    }
    
    func configure() {
        guard let title = viewModel.file?.title else { return }
        titleLabel.text = title
    }
}
