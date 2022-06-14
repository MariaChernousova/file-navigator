//
//  GridViewCell.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    private enum Constant {
        
    }
    
    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
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
    }
    
    private func setupAutoLayout() {
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeImageView.widthAnchor.constraint(equalToConstant: 44),
            typeImageView.heightAnchor.constraint(equalToConstant: 44),
            typeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            typeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: typeImageView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        typeImageView.image = UIImage(systemName: "folder")
    }
}
