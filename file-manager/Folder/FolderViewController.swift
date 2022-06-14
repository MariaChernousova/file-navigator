//
//  FolderViewController.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FolderViewController: UIViewController {
    
    enum ViewType {
        case grid
        case list
    }
    
    private var viewType = ViewType.grid
    
    private lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: applyCollectionViewLayout(viewType))
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
        image: UIImage(systemName: "square.grid.2x2"),
        style: .done,
        target: self,
        action: #selector(toggleSwitcher)
    )
    
    private lazy var dataSource = ItemsFetcherDataSource(collectionView: collectionView) { collectionView, indexPath, cellData -> UICollectionViewCell? in
        let item = self.viewModel.object(at: indexPath)
        guard let item = item, let title = item.title else { return nil }
        
        switch self.viewType {
        case .grid:
            guard let gridCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: GridViewCell.identifier, for: indexPath) as? GridViewCell else { return nil }
            if let folder = item as? Folder {
                gridCell.configure(with: title, image: "folder")
            } else if let file = item as? File {
                gridCell.configure(with: title, image: "doc.richtext")
            }
            collectionView.reloadData()
            return gridCell
        case .list:
            guard let lineCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: LineViewCell.identifier, for: indexPath) as? LineViewCell else { return nil }
            if let folder = item as? Folder {
                lineCell.configure(with: title, image: "folder")
            } else if let file = item as? File {
                lineCell.configure(with: title, image: "doc.richtext")
            }
            collectionView.reloadData()
            return lineCell
        }
    }
    
    private lazy var listViewLayout: UICollectionViewFlowLayout = {
        
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        collectionFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 0
        collectionFlowLayout.scrollDirection = .vertical
        return collectionFlowLayout
    }()
    
    private lazy var gridViewLayout: UICollectionViewFlowLayout = {
        
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        collectionFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 80) / 2 , height: UIScreen.main.bounds.height*0.16)
        collectionFlowLayout.minimumInteritemSpacing = 20
        collectionFlowLayout.minimumLineSpacing = 20
        return collectionFlowLayout
    }()
    
    private var viewModel: FolderViewModelProvider
    
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
        bind()
    }
    
    private func commonInit() {
        setupSubviews()
        setupAutoLayout()
    }
    
    private func createGridCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1 / 3
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func bind() {
        viewModel.updateAction = { [weak dataSource] snapshot in
            guard let dataSource = dataSource else { return }

            DispatchQueue.main.async {
                dataSource.apply(snapshot)
            }
        }
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        
        navigationItem.title = "Sample"
        navigationItem.rightBarButtonItems = [menuButtonItem,
                                              collectionTableSwitcherItem]
        
        collectionView.register(GridViewCell.self, forCellWithReuseIdentifier: GridViewCell.identifier)
        collectionView.register(LineViewCell.self, forCellWithReuseIdentifier: LineViewCell.identifier)
        
        collectionView.dataSource = dataSource
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

    private func applyCollectionViewLayout(_ viewType: ViewType) -> UICollectionViewLayout {
        switch viewType {
        case .grid:
            return gridViewLayout
        case .list:
            return listViewLayout
        }
    }
    
    @objc private func toggleSwitcher(sender: UIBarButtonItem) {
        if viewType == .grid {
            viewType = .list
        } else {
            viewType = .grid
        }
        
        switch viewType {
        case .grid:
            collectionView.setCollectionViewLayout(gridViewLayout, animated: true)
            sender.image = UIImage(systemName: "square.grid.2x2")
        case .list:
            collectionView.setCollectionViewLayout(listViewLayout, animated: true)
            sender.image = UIImage(systemName: "list.bullet")
        }
    }
}

