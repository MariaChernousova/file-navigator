//
//  FolderViewController.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FolderViewController: UIViewController {
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
        image: UIImage(systemName: "square.grid.2x2"),
        style: .done,
        target: self,
        action: #selector(toggleSwitcher)
    )
    
    private lazy var dataSource = ItemsFetcherDataSource(collectionView: collectionView) { collectionView, indexPath, cellData -> UICollectionViewCell? in
        let item = self.viewModel.object(at: indexPath)
        print(item)
        guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: GridViewCell.identifier, for: indexPath) as? GridViewCell,
              let lineCell = collectionView.dequeueReusableCell(withReuseIdentifier: LineViewCell.identifier, for: indexPath) as? LineViewCell else { return nil }
//        guard let title = cellData.title else { return nil }
//        
//        gridCell.configure(with: title)
//        lineCell.configure(with: title)
//        
        //        self.configureSnapshot(with: [cellData])
        
        return self.isTable ? lineCell : gridCell
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
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1 / 3
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func bind() {
        viewModel.updateAction = { [weak dataSource] snapshot in
            guard let dataSource = dataSource else { return }
//            var snapshot: ItemsFetcherSnapshot = data
//            snapshot.appendItems(data)
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
    
    //    private func configureSnapshot(with data: [Item]) {
    //        var snapshot = ItemsFetcherSnapshot()
    //        snapshot.appendSections([0])
    //        snapshot.appendItems(data, toSection: 0)
    //        dataSource.apply(snapshot)
    //    }
    
    @objc private func toggleSwitcher(sender: UIBarButtonItem) {
        isTable.toggle()
        sender.image = isTable ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2")
    }
}

