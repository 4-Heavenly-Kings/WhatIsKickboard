//
//  UseDetailViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/29/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

//MARK: - UseDetailViewController
final class UseDetailViewController: BaseViewController {
    
    // MARK: - Compoenets
    let useDetailView = UseDetailView()
    
    // MARK: - Properties
    private let viewModel: UseDetailViewModel
    
    init(viewModel: UseDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycels
    override func loadView() {
        super.loadView()
        
        view = useDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUIEvents()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.state.useDetailList
            .bind(to: useDetailView.getUseDetailTableView().rx.items(cellIdentifier: UseDetailTableViewCell.className, cellType: UseDetailTableViewCell.self)) { row, element, cell in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUIEvents() {
        useDetailView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        viewModel.action.onNext(.viewDidLoad)
    }
}
