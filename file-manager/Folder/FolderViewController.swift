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
        let spacing: CGFloat = 8
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createLineCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 8
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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
        collectionView.delegate = self
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
            return createGridCompositionalLayout()
        case .list:
            return createLineCompositionalLayout()
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
            collectionView.setCollectionViewLayout(createGridCompositionalLayout(), animated: true)
            sender.image = UIImage(systemName: "square.grid.2x2")
        case .list:
            collectionView.setCollectionViewLayout(createLineCompositionalLayout(), animated: true)
            sender.image = UIImage(systemName: "list.bullet")
        }
    }
}

extension FolderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }
}
