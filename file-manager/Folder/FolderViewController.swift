//
//  FolderViewController.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FolderViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    enum Section: CaseIterable {
        case main
    }
    
    private var isTable = false
    private lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: isTable ?
                                              UICollectionViewCompositionalLayout.list(using: configuration) :
                                                createCompositionalLayout())
        return collectionView
    }()
    
    
    private lazy var addFolderItem = UIAction(
        title: "Add folder",
        image: UIImage(systemName: "folder.badge.plus")
    ) { action in
        
        print("Add folder action was tapped")
    }
    
    private lazy var addFileItem = UIAction(
        title: "Add file",
        image: UIImage(systemName: "doc.badge.plus")
    ) { action in
        
        print("Add folder action was tapped")
    }
    
    private lazy var menu = UIMenu(
        title: "Add...",
        options: .displayInline,
        children: [addFileItem, addFolderItem]
    )
    
    private lazy var menuButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "plus"),
        menu: menu
    )
    
    private lazy var collectionTableSwitcherItem = UIBarButtonItem(
        image: isTable ?
        UIImage(systemName: "list.bullet") :
        UIImage(systemName: "square.grid.2x2"),
        style: .done,
        target: self,
        action: nil
    )
    
    private let viewModel: FolderViewModelProvider
    
    init(viewModel: FolderViewModelProvider) {
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
    }
    
    private func commonInit() {
        setupSubviews()
        setupAutoLayout()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1 / 3

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        
        navigationItem.title = "Sample"
        navigationItem.rightBarButtonItems = [menuButtonItem,
                                              collectionTableSwitcherItem]
    }
    
    private func setupAutoLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
