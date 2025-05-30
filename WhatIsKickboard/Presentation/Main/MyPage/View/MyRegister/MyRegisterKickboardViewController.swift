//
//  MyRegisterKickboardViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

// MARK: - MyRegisterKickboardViewController
final class MyRegisterKickboardViewController: BaseViewController {
    
    // MARK: - Compoenets
    let myRegisterKickboardView = MyRegisterKickboardView()
    
    private let viewModel: MyRegisterKickboardViewModel
    
    init(viewModel: MyRegisterKickboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = myRegisterKickboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
        bindUIEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setStyles() {
        super.setStyles()
        
    }
    
    override func setLayout() {
        super.setLayout()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.state.kickboardList
            .bind(to: myRegisterKickboardView.getMyRegisterTableView().rx.items(cellIdentifier: MyRegisterKickboardTableViewCell.className, cellType: MyRegisterKickboardTableViewCell.self)) { row, element, cell in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindAction() {
        viewModel.action.onNext(.viewDidLoad)
    }
    
    private func bindUIEvents() {
        myRegisterKickboardView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
