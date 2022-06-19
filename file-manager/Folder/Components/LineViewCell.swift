//
//  LineViewCell.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class LineViewCell: UICollectionViewCell {
    
    private enum Constant {
        static let borderWidth = 0.5
        static let cornerRadius = 10.0
        static let typeImageViewWidth = 44.0
        static let typeImageViewInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        static let titleLabelInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
    }
    
    var tapHandler: (() -> Void)?
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidTrigger))
    
    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupSubviews()
        setupAutoLayout()
    }
    
    private func setupSubviews() {
        contentView.addGestureRecognizer(tapGestureRecognizer)
        contentView.addSubview(typeImageView)
        contentView.addSubview(titleLabel)
        
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = Constant.borderWidth
        layer.cornerRadius = Constant.cornerRadius
    }

    private func setupAutoLayout() {
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeImageView.widthAnchor.constraint(lessThanOrEqualToConstant: Constant.typeImageViewWidth),
            typeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.typeImageViewInsets.top),
            typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.typeImageViewInsets.left),
            typeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.typeImageViewInsets.bottom),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.titleLabelInsets.top),
            titleLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: Constant.titleLabelInsets.left),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.titleLabelInsets.bottom)
        ])
    }
    
    func configure(with title: String, image: String) {
        titleLabel.text = title
        typeImageView.image = UIImage(systemName: image)
    }
    
    @objc private func tapGestureDidTrigger() {
        tapHandler?()
    }
}
