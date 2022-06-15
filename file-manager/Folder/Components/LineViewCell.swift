//
//  LineViewCell.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class LineViewCell: UICollectionViewCell {
    private enum Constant {
        
    }
    
    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
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
        contentView.addSubview(typeImageView)
        contentView.addSubview(titleLabel)
        
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
    }

    private func setupAutoLayout() {
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 44),
            typeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            typeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func configure(with title: String, image: String) {
        titleLabel.text = title
        typeImageView.image = UIImage(systemName: image)
    }
}
