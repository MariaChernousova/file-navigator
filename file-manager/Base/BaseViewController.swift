//
//  BaseViewController.swift
//  file-manager
//
//  Created by Chernousova Maria on 19.06.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(frame: .zero)
        loadingView.isHidden = true
        return loadingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUpUI()
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            view.bringSubviewToFront(loadingView)
            loadingView.startAnimation()
        } else {
            loadingView.stopAnimation()
        }
        
        loadingView.isHidden = !isLoading
    }
    
    private func setUpUI() {
        setupSubviews()
        setupAutoLayout()
    }
    
    private func setupSubviews() {
        view.addSubview(loadingView)
    }
    
    private func setupAutoLayout() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
