//
//  FolderViewController.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FolderViewController: BaseViewController {
    
    enum ViewType {
        case grid
        case list
    }
    
    private enum Constant {
        static let addFolderTitle = "Add folder"
        static let addFileTitle = "Add file"
        static let addActionTitle = "Ooops..."
        static let addActionMessage = "action will be added soon 😉"
        static let menuTitle = "Add..."
        static let alertActionTitle = "OK"
        
        static let addFolderImageName = "folder.badge.plus"
        static let addFileImageName = "doc.badge.plus"
        static let menuButtonImageName = "plus"
        static let gridImageName = "square.grid.2x2"
        static let listImageName = "list.bullet"
        static let folderImageName = "folder"
        static let fileImageName = "doc.richtext"
    }
    
    private var viewType = ViewType.grid
    
    private lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: applyCollectionViewLayout(viewType))
        return collectionView
    }()
    
    
    private lazy var addFolderItem = UIAction(
        title: Constant.addFolderTitle,
        image: UIImage(systemName: Constant.addFolderImageName)) { _ in
            self.showAlert(title: Constant.addActionTitle,
                           message: "\(Constant.addFolderTitle) \(Constant.addActionMessage)")
        }
    
    private lazy var addFileItem = UIAction(
        title: Constant.addFileTitle,
        image: UIImage(systemName: Constant.addFileImageName)) { _ in
            self.showAlert(title: Constant.addActionTitle,
                           message: "\(Constant.addFileTitle) \(Constant.addActionMessage)")
        }
    
    private lazy var menu = UIMenu(
        title: Constant.menuTitle,
        options: .displayInline,
        children: [addFileItem, addFolderItem]
    )
    
    private lazy var menuButtonItem = UIBarButtonItem(
        image: UIImage(systemName: Constant.menuButtonImageName),
        menu: menu
    )
    
    private lazy var collectionTableSwitcherItem = UIBarButtonItem(
        image: UIImage(systemName: Constant.gridImageName),
        style: .done,
        target: self,
        action: #selector(toggleSwitcher)
    )
    
    private lazy var dataSource = ItemsResultDataSource(collectionView: collectionView) { collectionView, indexPath, itemAdapter -> UICollectionViewCell? in
        switch self.viewType {
        case .grid:
            guard let gridCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: GridViewCell.identifier, for: indexPath) as? GridViewCell else { return nil }
            if let folder = itemAdapter as? FolderAdapter {
                gridCell.configure(with: itemAdapter.title, image: Constant.folderImageName)
            } else if let file = itemAdapter as? FileAdapter {
                gridCell.configure(with: itemAdapter.title, image: Constant.fileImageName)
            }
            gridCell.tapHandler = {
                self.viewModel.select(item: itemAdapter)
            }
            return gridCell
        case .list:
            guard let lineCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: LineViewCell.identifier, for: indexPath) as? LineViewCell else { return nil }
            if let folder = itemAdapter as? FolderAdapter {
                lineCell.configure(with: itemAdapter.title, image: Constant.folderImageName)
            } else if let file = itemAdapter as? FileAdapter {
                lineCell.configure(with: itemAdapter.title, image: Constant.fileImageName)
            }
            lineCell.tapHandler = {
                self.viewModel.select(item: itemAdapter)
            }
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
        bind()
        
        viewModel.didLoad()
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
        viewModel.setUpdateHandler { [weak dataSource] snapshot in
            guard let dataSource = dataSource else { return }
            DispatchQueue.main.async {
                dataSource.apply(snapshot)
            }
        }
        
        viewModel.showErrorAlert = { title, message in
            self.showAlert(title: title, message: message)
        }
        
        viewModel.updateLoading = { isLoading in
            self.setLoading(isLoading)
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
            return createGridCompositionalLayout()
        case .list:
            return createLineCompositionalLayout()
        }
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
    
    @objc private func toggleSwitcher(sender: UIBarButtonItem) {
        if viewType == .grid {
            viewType = .list
        } else {
            viewType = .grid
        }
        
        switch viewType {
        case .grid:
            collectionView.setCollectionViewLayout(createGridCompositionalLayout(), animated: true) { _ in
                var snapshot = self.dataSource.snapshot()
                let identifiers = snapshot.sectionIdentifiers
                snapshot.reloadSections(identifiers)
                self.dataSource.apply(snapshot)
            }
            sender.image = UIImage(systemName: Constant.gridImageName)
        case .list:
            collectionView.setCollectionViewLayout(createLineCompositionalLayout(), animated: true) { _ in
                var snapshot = self.dataSource.snapshot()
                let identifiers = snapshot.sectionIdentifiers
                snapshot.reloadSections(identifiers)
                self.dataSource.apply(snapshot)
            }
            sender.image = UIImage(systemName: Constant.listImageName)
        }
    }
}
